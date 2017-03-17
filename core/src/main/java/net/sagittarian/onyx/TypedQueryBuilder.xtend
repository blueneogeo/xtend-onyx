package net.sagittarian.onyx

import com.onyx.persistence.IManagedEntity
import com.onyx.persistence.manager.PersistenceManager
import com.onyx.persistence.query.Query
import com.onyx.persistence.query.QueryCriteria
import com.onyx.persistence.query.QueryOrder
import com.onyx.persistence.update.AttributeUpdate
import java.util.AbstractList
import java.util.List
import java.util.Map
import net.sagittarian.onyx.annotations.Fluent
import net.sagittarian.onyx.metadata.MetaData
import net.sagittarian.onyx.metadata.Selector

/**
 * Lets you build Onyx queries with static code, using the Data metadata
 * inner classes generated by the OnyxField and OnyxJoin active annotations.
 * To be ale to use this class with entities, they have to be annotated 
 * with OnyxField and OnyxJoin.
 * <p>
 * It is meant to be used together with the OnyxExtensions.
 * <p>
 * For example:
 * <p>
 * <pre>
 * // import the extensions
 * import static extension nl.kii.onyx.OnyxExtensions.*
 * // save an example entity
 * db.saveEntity(new User => [
 *    username = 'Jason'
 *    address = new Address => [
 *       streetName = 'Homeland'
 *    ]
 * ])
 * // perform the query
 * val results = db.query(User.Data)
 *    .where [ username == 'Jason' && address_streetName == 'Homeland' ]
 *    .order [ +id ]
 *    .lazyList
 * // print results
 * for(result : results) {
 *    println(result)
 * }
 * </pre>
 */
class TypedQueryBuilder<T extends IManagedEntity, M extends MetaData<T>> {
	
	val PersistenceManager session
	val Class<M> metaType
	val M metadata

	List<Selector<?>> fields
	QueryCriteria criteria
	List<AttributeUpdate<?>> updates
	List<QueryOrder> orders
	Integer firstRow
	Integer maxResults
	Integer pageNr
	IntegerRange range
	Object partition
	
	/**
	 * Create the builder. The metaType is the generated Data class inside the entity.
	 */
	new(PersistenceManager session, Class<M> metaType) {
		this.session = session
		this.metaType = metaType
		this.metadata = metaType.newInstance
	}
	
	@Fluent
	def TypedQueryBuilder<T, M> where((M)=>QueryCriteria... criteriaFns) {
		val newCriteria = criteriaFns.map [ apply(metadata) ]
		for(newCriterium : newCriteria) {
			if(this.criteria === null) {
				this.criteria = newCriterium
			} else {
				this.criteria.and(newCriterium)
			}
		}
		this
	}

	/**
	 * Order the found entities by the passed fields in the closure.
	 * It is ordered first by the first field, and if equal, then
	 * the second field, etc.
	 * <p>
	 * Pass each field inside a closure to get code completion
	 * of the possible fields.
	 * <p>
	 * <pre>Example:
	 * db.query(User.Data)
	 *    .order ([username], [email])
	 *    .list
	 */	
	@Fluent
	def TypedQueryBuilder<T, M> order((M)=>QueryOrder... orderFns) {
		if(orders === null) orders = newLinkedList
		orders.addAll(orderFns.map [ apply(metadata) ])
		this 
	}
	
	/**
	 * Set multiple fields to update with a new value. Use the => operator overload
	 * from OnyxExtensions to set the new value.
	 * <p>
	 * Pass each field update inside a closure to get code completion
	 * of the possible fields.
	 * <p>
	 * <pre>Example:
	 * db.query(User.Data)
	 *    .set([ username => 'my new name' ], [ age => 30 ])
	 *    .where [ username == 'my old name' ]
	 *    .update
	 */	
	@Fluent
	def TypedQueryBuilder<T, M> set((M)=>AttributeUpdate<?>... updateFns) {
		if(updates === null) updates = newLinkedList
		updates.addAll(updateFns.map [ apply(metadata) ])
		this
	}

	/**
	 * Skip the first [rowsToSkip] returned results.
	 */	
	@Fluent
	def TypedQueryBuilder<T, M> skip(int rowsToSkip) {
		this.firstRow = rowsToSkip
		this
	}
	
	/**
	 * Return at most [maxResults] entities.
	 */	
	@Fluent
	def TypedQueryBuilder<T, M> limit(int maxResults) {
		this.maxResults = maxResults
		this
	}

	/**
	 * Set a range of results. Starts counting at 1.
	 * <p>
	 * For example: range(4..6) only returns the 4th, 5th and 6th result. 
	 */	
	@Fluent
	def TypedQueryBuilder<T, M> range(IntegerRange range) {
		this.range = range
		this
	}

	/**
	 * Gets a specific page of the results. Starts counting at 1.
	 * <p>
	 * For example: page(2, 3) only returns the 4th, 5th and 6th result.
	 */	
	@Fluent
	def TypedQueryBuilder<T, M> page(int pageNr) {
		this.pageNr = pageNr
		this
	}
	
	/**
	 * Set the partition to query.
	 */
	@Fluent
	def TypedQueryBuilder<T, M> partition(Object partition) {
		this.partition = partition
		this
	}
	
	/** 
	 * Gets the query you have built so far.
	 * This also allows you to reuse a query for performance.
	 */	
	def build() {
		new Query(metadata.entityType) => [
			if(fields !== null) it.selections = fields.map [ name ]
			if(criteria !== null) it.criteria = criteria
			if(updates !== null) it.updates = newLinkedList(updates) // hack around generic type warning
			if(orders !== null) it.queryOrders = orders
			if(maxResults !== null) it.maxResults = maxResults
			if(firstRow !== null) it.firstRow = firstRow
			if(partition !== null) it.partition = partition
			if(range !== null) {
				it.firstRow = it.firstRow + range.start - 1
				it.maxResults = Math.min(range.size, it.maxResults) 
			}
			if(pageNr !== null && maxResults !== null) {
				it.firstRow = ((pageNr - 1) * it.maxResults) + it.firstRow
			}
		]
	}

	/** Gets all results as a prefilled List */	
	def List<T> list() {
		session.executeQuery(build)
	}

	/** 
	 * Gets all results as a lazy list, meaning the values of the entities are not yet hydrated,
	 * but will be once they are requested.
	 */	
	def List<T> lazyList() {
		val query = session.executeLazyQuery(build)
		new AbstractList<T> {
			
			override get(int index) {
				query.get(index) as T
			}
			
			override size() {
				query.size
			}
			
		}
	}

	/**
	 * Get all results as a list of values.
	 * <p>
	 * Get only the passed field of the found entities.
	 * Pass each field inside a closure to get code completion
	 * of the possible fields.
	 * <p>
	 * <pre>Example: 
	 * db.query(User.Data)
	 *    .list [username]
	 */
	def <E> List<E> list((M)=>Selector<E> fieldFn) {
		val field = fieldFn.apply(metadata)
		val fieldName = field.name
		fields = #[field]
		val List<Map<String, E>> list = session.executeQuery(build)
		list.map [ get(fieldName) as E ]
	}

	/**
	 * Get all results as a list of fieldname->value mappings.
	 * <p>
	 * Get only the passed fields of the found entities.
	 * Pass each field inside a closure to get code completion
	 * of the possible fields.
	 * <p>
	 * <pre>Example: 
	 * db.query(User.Data)
	 *    .list([id], [username])
	 */
	def List<Map<String, ?>> list((M)=>Selector<?>... fieldFns) {
		fields = fieldFns.map [ apply(metadata) ]
		session.executeQuery(build)
	}

	/**
	 * Get all results as a lazily hydrated list of values.
	 * <p>
	 * Get only the passed field of the found entities.
	 * Pass each field inside a closure to get code completion
	 * of the possible fields.
	 * <p>
	 * <pre>Example: 
	 * db.query(User.Data)
	 *    .list [username]
	 */
	def <E> List<E> lazyList((M)=>Selector<E> fieldFn) {
		val field = fieldFn.apply(metadata)
		val fieldName = field.name
		fields = #[field]
		val List<Map<String, E>> list = session.executeLazyQuery(build)
		val result = list.map [ get(fieldName) as E ]
		new AbstractList<E> {
			
			override get(int index) {
				result.get(index) as E
			}
			
			override size() {
				result.size
			}
			
		}
	}

	/**
	 * Get all results as a list lazily hydrated of fieldname->value mappings.
	 * <p>
	 * Get only the passed fields of the found entities.
	 * Pass each field inside a closure to get code completion
	 * of the possible fields.
	 * <p>
	 * <pre>Example: 
	 * db.query(User.Data)
	 *    .list([id], [username])
	 */
	def List<Map<String, ?>> lazyList((M)=>Selector<?>... fieldFns) {
		fields = fieldFns.map [ apply(metadata) ]
		val result = session.executeLazyQuery(build)
		new AbstractList<Map<String, ?>> {
			
			override get(int index) {
				result.get(index) as Map<String, ?>
			}
			
			override size() {
				result.size
			}
			
		}
		
	}
		
	/** 
	 * Gets the first matching result, or null if there is no result. 
	 */
	def T first() {
		maxResults = 1
		val List<T> list = session.executeQuery(build)
		list.head
	}

	/**
	 * Gets the amount of results matching the query
	 */	
	def int count() {
		session.executeLazyQuery(build).size
	}

	/**
	 * Updates the entities that match the query with the updates
	 * that you specified with the .set method.
	 * @return the amount of updated entities
	 */
	def int update() {
		if(updates === null || updates.empty) throw new Exception('Cannot perform an update query without setting attribute updates. Did you forget to add a .set [ ] ?')
		session.executeUpdate(build)
	}

	/**
	 * Delete entities matching the query.
	 * @return the amount of removed entities
	 */
	def int delete() {
		session.executeDelete(build)
	}

}
