package nl.kii.onyx.test

import com.onyx.persistence.factory.PersistenceManagerFactory
import com.onyx.persistence.factory.impl.CacheManagerFactory
import com.onyx.persistence.manager.PersistenceManager
import com.onyx.persistence.query.QueryCriteria
import com.onyx.persistence.query.QueryCriteriaOperator
import nl.kii.onyx.test.entities.Person
import org.junit.After
import org.junit.Before
import org.junit.Test

import static extension nl.kii.onyx.OnyxExtensions.*
import nl.kii.onyx.test.entities.Address

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
//			val person = new Person => [ firstName = 'Christian'+i lastName = 'Vogel'+i ]
//			val address1 = new Address => [ street = 'sluisvaart' houseNr = 98 ]
//			val address2 = new Address => [ street = 'binnenvaart' houseNr = 4 ]
			db.saveEntity( new Person => [ firstName = 'Christian'+i lastName = 'Vogel'+i ] )
		}

		val c1 = new QueryCriteria('firstName', QueryCriteriaOperator.STARTS_WITH, 'Christian')
		val c2 = new QueryCriteria('id', QueryCriteriaOperator.GREATER_THAN_EQUAL, 30)
		val data = db.list(Person, c1.and(c2)) 
		println(data)
	}

	@Test
	def void testXtendQuery() {
		for(i : 1..50) {
			db.saveEntity( new Person => [ firstName = 'Christian'+i lastName = 'Vogel'+i ] )
		}
		// println(db.query(Person).list)
		val christians = db
			.from (Person.Data)
			//.select [ firstName + lastName ]
			.where [ firstName == 'Christian' ]
//			// .order [ lastName + !firstName ]
			.list
		println(christians)

		val addresses = db
			.from (Address.Data)
			//.select [ firstName + lastName ]
			.where [ person == 'Christian' ]
//			// .order [ lastName + !firstName ]
			.list
		println(addresses)
	}
	
}
