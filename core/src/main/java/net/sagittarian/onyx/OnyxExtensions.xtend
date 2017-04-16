package net.sagittarian.onyx

import com.onyx.exception.EntityException
import com.onyx.persistence.IManagedEntity
import com.onyx.persistence.ManagedEntity
import com.onyx.persistence.manager.PersistenceManager
import com.onyx.persistence.query.QueryCriteria
import com.onyx.persistence.query.QueryOrder
import com.onyx.persistence.update.AttributeUpdate
import java.util.Date
import java.util.List
import net.sagittarian.onyx.metadata.Field
import net.sagittarian.onyx.metadata.MetaData
import net.sagittarian.onyx.metadata.Selector

import static com.onyx.persistence.query.QueryCriteriaOperator.*

class OnyxExtensions {
	
	/** Same as saveEntity, but typed */
	def static <T extends IManagedEntity> T save(PersistenceManager db, T entity) throws EntityException {
		db.saveEntity(entity) as T
	}

	/** Same as saveEntities, but typed and returns the indexed entities */
	def static <T extends IManagedEntity> List<T> save(PersistenceManager db, List<T> entities) throws EntityException {
		db.saveEntities(entities)
		entities
	}
	
	/** Create a query */
	def static <T extends ManagedEntity, M extends MetaData<T>> TypedQuery<T, M> query(PersistenceManager session, Class<M> metaDataType) {
		new TypedQuery(session, metaDataType)
	}
	
	// QUERY CRITERIA /////////////////////////////////////////////////////////
	
	def static &&(QueryCriteria q1, QueryCriteria q2) {
		q1.and(q2)
	}

	def static ||(QueryCriteria q1, QueryCriteria q2) {
		q1.or(q2)
	}
	
	// equals //
	
	def static ==(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, EQUAL, value)
	}

	def static ==(Selector<Long> selector, long value) {
		new QueryCriteria(selector.name, EQUAL, value)
	}

	def static ==(Selector<Integer> selector, int value) {
		new QueryCriteria(selector.name, EQUAL, value)
	}

	def static ==(Selector<Boolean> selector, boolean value) {
		new QueryCriteria(selector.name, EQUAL, value)
	}

	def static ==(Selector<Date> selector, Date value) {
		new QueryCriteria(selector.name, EQUAL, value)
	}

	def static ==(Selector<Float> selector, float value) {
		new QueryCriteria(selector.name, EQUAL, value)
	}

	def static ==(Selector<Byte> selector, byte value) {
		new QueryCriteria(selector.name, EQUAL, value)
	}

	def static ==(Selector<Short> selector, short value) {
		new QueryCriteria(selector.name, EQUAL, value)
	}

	def static <F extends ManagedEntity> ==(Selector<F> selector, F value) {
		new QueryCriteria(selector.name, EQUAL, value)
	}

	def static <E extends Enum<?>> ==(Selector<E> selector, E value) {
		new QueryCriteria(selector.name, EQUAL, value)
	}

	// not equals //

	def static !=(Selector<String> selector, String value) {
		if(value === null) new QueryCriteria(selector.name, NOT_NULL)
		else new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	def static !=(Selector<Long> selector, Long value) {
		if(value === null) new QueryCriteria(selector.name, NOT_NULL)
		else new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	def static !=(Selector<Integer> selector, Integer value) {
		if(value === null) new QueryCriteria(selector.name, NOT_NULL)
		else new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	def static !=(Selector<Double> selector, Double value) {
		if(value === null) new QueryCriteria(selector.name, NOT_NULL)
		else new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	def static !=(Selector<Boolean> selector, boolean value) {
		new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	def static !=(Selector<Date> selector, Date value) {
		new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	def static !=(Selector<Float> selector, float value) {
		new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	def static !=(Selector<Byte> selector, byte value) {
		new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	def static !=(Selector<Short> selector, short value) {
		new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	def static <F extends ManagedEntity> !=(Selector<F> selector, F value) {
		new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	def static <E extends Enum<?>> !=(Selector<E> selector, E value) {
		new QueryCriteria(selector.name, NOT_EQUAL, value)
	}

	// larger than //

	def static >(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, GREATER_THAN, value)
	}

	def static >(Selector<Long> selector, long value) {
		new QueryCriteria(selector.name, GREATER_THAN, value)
	}

	def static >(Selector<Integer> selector, int value) {
		new QueryCriteria(selector.name, GREATER_THAN, value)
	}

	def static >(Selector<Double> selector, double value) {
		new QueryCriteria(selector.name, GREATER_THAN, value)
	}

	def static >(Selector<Boolean> selector, boolean value) {
		new QueryCriteria(selector.name, GREATER_THAN, value)
	}

	def static >(Selector<Date> selector, Date value) {
		new QueryCriteria(selector.name, GREATER_THAN, value)
	}

	def static >(Selector<Float> selector, float value) {
		new QueryCriteria(selector.name, GREATER_THAN, value)
	}

	def static >(Selector<Byte> selector, byte value) {
		new QueryCriteria(selector.name, GREATER_THAN, value)
	}

	def static >(Selector<Short> selector, short value) {
		new QueryCriteria(selector.name, GREATER_THAN, value)
	}

	// larger or equals //

	def static >=(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Long> selector, long value) {
		new QueryCriteria(selector.name, GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Integer> selector, int value) {
		new QueryCriteria(selector.name, GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Double> selector, double value) {
		new QueryCriteria(selector.name, GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Boolean> selector, boolean value) {
		new QueryCriteria(selector.name, GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Date> selector, Date value) {
		new QueryCriteria(selector.name, GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Float> selector, float value) {
		new QueryCriteria(selector.name, GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Byte> selector, byte value) {
		new QueryCriteria(selector.name, GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Short> selector, short value) {
		new QueryCriteria(selector.name, GREATER_THAN_EQUAL, value)
	}

	// smaller than //

	def static <(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, LESS_THAN, value)
	}

	def static <(Selector<Long> selector, long value) {
		new QueryCriteria(selector.name, LESS_THAN, value)
	}

	def static <(Selector<Integer> selector, int value) {
		new QueryCriteria(selector.name, LESS_THAN, value)
	}

	def static <(Selector<Double> selector, double value) {
		new QueryCriteria(selector.name, LESS_THAN, value)
	}

	def static <(Selector<Boolean> selector, boolean value) {
		new QueryCriteria(selector.name, LESS_THAN, value)
	}

	def static <(Selector<Date> selector, Date value) {
		new QueryCriteria(selector.name, LESS_THAN, value)
	}

	def static <(Selector<Float> selector, float value) {
		new QueryCriteria(selector.name, LESS_THAN, value)
	}

	def static <(Selector<Byte> selector, byte value) {
		new QueryCriteria(selector.name, LESS_THAN, value)
	}

	def static <(Selector<Short> selector, short value) {
		new QueryCriteria(selector.name, LESS_THAN, value)
	}

	// smaller or equals //

	def static <=(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Long> selector, long value) {
		new QueryCriteria(selector.name, LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Integer> selector, int value) {
		new QueryCriteria(selector.name, LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Double> selector, double value) {
		new QueryCriteria(selector.name, LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Boolean> selector, boolean value) {
		new QueryCriteria(selector.name, LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Date> selector, Date value) {
		new QueryCriteria(selector.name, LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Float> selector, float value) {
		new QueryCriteria(selector.name, LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Byte> selector, byte value) {
		new QueryCriteria(selector.name, LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Short> selector, short value) {
		new QueryCriteria(selector.name, LESS_THAN_EQUAL, value)
	}

	// in //

	/** The value is one of the passed values */
	def static <T extends Object> in(Selector<T> selector, T... values) {
		new QueryCriteria(selector.name, IN, newLinkedList(values))
	}

	/** The value is NOT one of the passed values */
	def static <T extends Object> notIn(Selector<T> selector, T... values) {
		new QueryCriteria(selector.name, NOT_IN, newLinkedList(values))
	}

	// string operations //

	def static contains(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, CONTAINS, value)
	}

	def static matches(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, MATCHES, value)
	}

	def static like(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, LIKE, value)
	}

	def static startsWith(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, STARTS_WITH, value)
	}

	def static notStartsWith(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, NOT_STARTS_WITH, value)
	}
	
	// QUERY UPDATES //////////////////////////////////////////////////////////
	
	/** Assign the new value to the selected field */
	def static =>(Field<String> selector, String value) {
		new AttributeUpdate(selector.name, value)
	}	

	/** Assign the new value to the selected field */
	def static =>(Field<Long> selector, long value) {
		new AttributeUpdate(selector.name, value)
	}

	/** Assign the new value to the selected field */
	def static =>(Field<Integer> selector, int value) {
		new AttributeUpdate(selector.name, value)
	}

	/** Assign the new value to the selected field */
	def static =>(Field<Double> selector, double value) {
		new AttributeUpdate(selector.name, value)
	}

	// QUERY ORDER ////////////////////////////////////////////////////////////
	
	/** In ascending order */
	def static +(Selector<?> selector) {
		new QueryOrder(selector.name, true)
	}

	/** In descending order */
	def static -(Selector<?> selector) {
		new QueryOrder(selector.name, false)
	}
	
}

