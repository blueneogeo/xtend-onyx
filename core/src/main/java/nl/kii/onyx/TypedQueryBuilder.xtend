package nl.kii.onyx

import com.onyx.persistence.ManagedEntity
import com.onyx.persistence.manager.PersistenceManager
import com.onyx.persistence.query.Query
import com.onyx.persistence.query.QueryCriteria
import com.onyx.persistence.query.QueryOrder
import java.util.List
import nl.kii.onyx.annotations.MetaData

class TypedQueryBuilder<T extends ManagedEntity, M extends MetaData<T>> {
	
	val PersistenceManager session
	val Class<M> metaType
	val M metaTypeInstance

	List<String> fields
	QueryCriteria criteria
	List<QueryOrder> orders
	Integer maxResults
	
	new(PersistenceManager session, Class<M> metaType) {
		this.session = session
		this.metaType = metaType
		this.metaTypeInstance = metaType.newInstance
	}
	
	def TypedQueryBuilder<T, M> select(String... fields) {
		this.fields = newArrayList(fields)
		this
	}

	def TypedQueryBuilder<T, M> where((M)=>QueryCriteria criteriaFn) {
		val newCriteria = criteriaFn.apply(metaTypeInstance)
		this.criteria = if(this.criteria === null) {
			newCriteria
		} else {
			this.criteria.and(newCriteria)
		}
		this
	}
	
	def TypedQueryBuilder<T, M> order((M)=>List<QueryOrder> selectorsFn) {
		val newOrders = selectorsFn.apply(metaTypeInstance)
		if(this.orders === null) {
			this.orders = newOrders
		} else {
			this.orders.addAll(newOrders)
		}
		this 
	}
	
	/** Gets the query you have built so far */	
	def build() {
		new Query(metaTypeInstance.entityType) => [
			// if(selections !== null) query.selections = selections.map [ name ]
			if(criteria !== null) it.criteria = criteria
			if(orders !== null) it.queryOrders = orders.toList
			if(maxResults !== null) it.maxResults = maxResults
		]
	}
	
	def List<T> list() {
		session.executeQuery(build)
	}

}
