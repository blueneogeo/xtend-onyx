package nl.kii.onyx

import com.onyx.persistence.ManagedEntity
import com.onyx.persistence.manager.PersistenceManager
import com.onyx.persistence.query.QueryCriteria
import com.onyx.persistence.query.QueryCriteriaOperator
import nl.kii.onyx.annotations.Field
import nl.kii.onyx.annotations.MetaData

class OnyxExtensions {
	
	def static <T extends ManagedEntity, M extends MetaData<T>> TypedQueryBuilder<T, M> from(PersistenceManager session, Class<M> metaDataType) {
		new TypedQueryBuilder(session, metaDataType)
	}
	
	def static +(Field<?> field1, Field<?> field2) {
		#[ field1, field2 ]
	}
	
	def static &&(QueryCriteria q1, QueryCriteria q2) {
		q1.and(q2)
	}

	def static ||(QueryCriteria q1, QueryCriteria q2) {
		q1.or(q2)
	}
	
	def static ==(Field<String> field, String value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.EQUAL, value)
	}

	def static ==(Field<Long> field, long value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.EQUAL, value)
	}

	def static ==(Field<Integer> field, int value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.EQUAL, value)
	}

	def static ==(Field<Double> field, double value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.EQUAL, value)
	}

	def static >(Field<String> field, String value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.GREATER_THAN, value)
	}

	def static >(Field<Long> field, long value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.GREATER_THAN, value)
	}

	def static >(Field<Integer> field, int value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.GREATER_THAN, value)
	}

	def static >(Field<Double> field, double value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.GREATER_THAN, value)
	}

	def static >=(Field<String> field, String value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.GREATER_THAN_EQUAL, value)
	}

	def static >=(Field<Long> field, long value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.GREATER_THAN_EQUAL, value)
	}

	def static >=(Field<Integer> field, int value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.GREATER_THAN_EQUAL, value)
	}

	def static >=(Field<Double> field, double value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.GREATER_THAN_EQUAL, value)
	}

	def static <(Field<String> field, String value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.LESS_THAN, value)
	}

	def static <(Field<Long> field, long value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.LESS_THAN, value)
	}

	def static <(Field<Integer> field, int value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.LESS_THAN, value)
	}

	def static <(Field<Double> field, double value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.LESS_THAN, value)
	}

	def static <=(Field<String> field, String value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.LESS_THAN_EQUAL, value)
	}

	def static <=(Field<Long> field, long value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.LESS_THAN_EQUAL, value)
	}

	def static <=(Field<Integer> field, int value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.LESS_THAN_EQUAL, value)
	}

	def static <=(Field<Double> field, double value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.LESS_THAN_EQUAL, value)
	}

	def static startsWith(Field<String> field, String value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.STARTS_WITH, value)
	}

	def static notStartsWith(Field<String> field, String value) {
		new QueryCriteria(field.name, QueryCriteriaOperator.NOT_STARTS_WITH, value)
	}

	def static notNull(Field<?> field) {
		new QueryCriteria(field.name, QueryCriteriaOperator.NOT_NULL)
	}
	
}

