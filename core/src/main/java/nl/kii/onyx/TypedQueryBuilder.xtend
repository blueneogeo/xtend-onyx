package nl.kii.onyx

import com.onyx.persistence.ManagedEntity
import com.onyx.persistence.manager.PersistenceManager
import com.onyx.persistence.query.QueryCriteria
import java.util.List
import nl.kii.onyx.annotations.MetaData

class TypedQueryBuilder<T extends ManagedEntity, M extends MetaData<T>> {
	
	val PersistenceManager session
	val Class<T> type
	QueryCriteria criteria
	List<String> fields
	
	new(PersistenceManager session, Class<T> type) {
		this.session = session
		this.type = type
	}
	
	def TypedQueryBuilder<T, M> select(String... fields) {
		this.fields = newArrayList(fields)
		this
	}
	
	def List<T> list() {
		if(criteria === null) {
			session.list(type)
		} else {
			session.list(type, criteria)
		}
	}

	def TypedQueryBuilder<T, M> where((M)=>QueryCriteria criteriaFn) {
		// TODO: where(criteriaFn.apply())
	}
	
	def TypedQueryBuilder<T, M> where(QueryCriteria criteria) {
		this.criteria = if(this.criteria === null) {
			criteria
		} else {
			this.criteria.and(criteria)
		}
		this
	}
	
}
