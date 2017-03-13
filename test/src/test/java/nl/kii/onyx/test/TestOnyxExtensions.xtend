package nl.kii.onyx.test

import com.onyx.persistence.factory.PersistenceManagerFactory
import com.onyx.persistence.factory.impl.CacheManagerFactory
import com.onyx.persistence.manager.PersistenceManager
import com.onyx.persistence.query.QueryCriteria
import com.onyx.persistence.query.QueryCriteriaOperator
import nl.kii.onyx.test.entities.Address
import nl.kii.onyx.test.entities.Person
import org.junit.After
import org.junit.Before
import org.junit.Test

import static extension nl.kii.onyx.OnyxExtensions.*
import com.onyx.persistence.query.QueryOrder

class TestOnyxExtensions {

	PersistenceManagerFactory factory
	PersistenceManager db 

	@Before
	def void startDB() {
		factory = new CacheManagerFactory
		factory.initialize
		db = factory.persistenceManager
	}

	@After
	def void stopDB() {
		factory.close
	}

	@Test
	def void testInsertAndGet() {
		val person = new Person => [
			firstName = 'Christian'
			lastName = 'Vogel'
		]
		db.saveEntity(person)
		val saved = db.findById(Person, person.id)
		println(saved)
	}

	@Test
	def void testQuery() {
		for(i : 1..50) {
			val person = new Person => [ firstName = 'Christian'+i lastName = 'Vogel'+i ]
			db.saveEntity(person)
		}

		val c1 = new QueryCriteria('id', QueryCriteriaOperator.GREATER_THAN, 10L)
		val c2 = new QueryCriteria('id', QueryCriteriaOperator.LESS_THAN, 15L)
		val data = db.list(Person, c2.and(c1), new QueryOrder('id')) 
		println(data)
	}

	@Test
	def void testXtendQuery() {
		for(i : 1..50) {
			db.saveEntity( new Person => [ 
				firstName = 'Christian'+i 
				lastName = 'Vogel'+i
				age = 60 - i
				address = new Address => [
					street = 'Sluisvaart'
					houseNr = 98-i
				]
			] )
		}
		
		val results = db
			.from(Person.Data)
			.where [ id > 3 && address_houseNr > 20 ]
			.order [ +id ]
			.list
		
		println(results)
	}
	
}
