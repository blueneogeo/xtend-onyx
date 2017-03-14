package nl.kii.onyx

import com.onyx.persistence.ManagedEntity
import com.onyx.persistence.manager.PersistenceManager
import com.onyx.persistence.query.QueryCriteria
import com.onyx.persistence.query.QueryCriteriaOperator
import com.onyx.persistence.query.QueryOrder
import com.onyx.persistence.update.AttributeUpdate
import nl.kii.onyx.annotations.MetaData
import nl.kii.onyx.annotations.Selector
import nl.kii.onyx.annotations.Field

class OnyxExtensions {
	
	/** Create a query */
	def static <T extends ManagedEntity, M extends MetaData<T>> TypedQueryBuilder<T, M> query(PersistenceManager session, Class<M> metaDataType) {
		new TypedQueryBuilder(session, metaDataType)
	}
	
	// QUERY CRITERIA /////////////////////////////////////////////////////////
	
	def static &&(QueryCriteria q1, QueryCriteria q2) {
		q1.and(q2)
	}

	def static ||(QueryCriteria q1, QueryCriteria q2) {
		q1.or(q2)
	}
	
	def static ==(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.EQUAL, value)
	}

	def static ==(Selector<Long> selector, long value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.EQUAL, value)
	}

	def static ==(Selector<Integer> selector, int value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.EQUAL, value)
	}

	def static ==(Selector<Double> selector, double value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.EQUAL, value)
	}

	def static !=(Selector<String> selector, String value) {
		if(value === null) new QueryCriteria(selector.name, QueryCriteriaOperator.NOT_NULL)
		else new QueryCriteria(selector.name, QueryCriteriaOperator.NOT_EQUAL, value)
	}

	def static !=(Selector<Long> selector, Long value) {
		if(value === null) new QueryCriteria(selector.name, QueryCriteriaOperator.NOT_NULL)
		else new QueryCriteria(selector.name, QueryCriteriaOperator.NOT_EQUAL, value)
	}

	def static !=(Selector<Integer> selector, Integer value) {
		if(value === null) new QueryCriteria(selector.name, QueryCriteriaOperator.NOT_NULL)
		else new QueryCriteria(selector.name, QueryCriteriaOperator.NOT_EQUAL, value)
	}

	def static !=(Selector<Double> selector, Double value) {
		if(value === null) new QueryCriteria(selector.name, QueryCriteriaOperator.NOT_NULL)
		else new QueryCriteria(selector.name, QueryCriteriaOperator.NOT_EQUAL, value)
	}

	def static >(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.GREATER_THAN, value)
	}

	def static >(Selector<Long> selector, long value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.GREATER_THAN, value)
	}

	def static >(Selector<Integer> selector, int value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.GREATER_THAN, value)
	}

	def static >(Selector<Double> selector, double value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.GREATER_THAN, value)
	}

	def static >=(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Long> selector, long value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Integer> selector, int value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.GREATER_THAN_EQUAL, value)
	}

	def static >=(Selector<Double> selector, double value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.GREATER_THAN_EQUAL, value)
	}

	def static <(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.LESS_THAN, value)
	}

	def static <(Selector<Long> selector, long value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.LESS_THAN, value)
	}

	def static <(Selector<Integer> selector, int value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.LESS_THAN, value)
	}

	def static <(Selector<Double> selector, double value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.LESS_THAN, value)
	}

	def static <=(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Long> selector, long value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Integer> selector, int value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.LESS_THAN_EQUAL, value)
	}

	def static <=(Selector<Double> selector, double value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.LESS_THAN_EQUAL, value)
	}

	def static startsWith(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.STARTS_WITH, value)
	}

	def static notStartsWith(Selector<String> selector, String value) {
		new QueryCriteria(selector.name, QueryCriteriaOperator.NOT_STARTS_WITH, value)
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

