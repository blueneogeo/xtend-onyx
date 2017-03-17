package net.sagittarian.onyx.test

import com.onyx.persistence.factory.PersistenceManagerFactory
import com.onyx.persistence.factory.impl.CacheManagerFactory
import com.onyx.persistence.manager.PersistenceManager
import com.onyx.persistence.query.QueryCriteria
import com.onyx.persistence.query.QueryCriteriaOperator
import com.onyx.persistence.query.QueryOrder
import net.sagittarian.onyx.test.entities.Address
import net.sagittarian.onyx.test.entities.Person
import org.junit.After
import org.junit.Before
import org.junit.Test

import static extension net.sagittarian.onyx.OnyxExtensions.*

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
		
		val results = db.query(Address.Data)
			.order [ +houseNr ]
			.list ( [ street ], [ occupants_firstName ] )
		
		for(result : results) {
			println(result)
		}		

		db.query(Person.Data)
			.where [ id > 5 ]
			.delete
		
		db.query(Person.Data)
			.set [ firstName => 'Jacob' ]
			.where [ firstName == 'Christian2' ]
			.update
		
		val results2 = db.query(Person.Data)
			.where [ id > 3 && address_houseNr > 20 ]
			.order([-id], [-address_houseNr])
			.lazyList
		
		for(result : results2) {
			println(result)
		}
	}

	@Test
	def void testXtendQuery2() {
		val person1 = db.save( new Person => [
			firstName = 'Sally'
			lastName = 'Sad'
		])
		val person2 = db.save( new Person => [
			firstName = 'Jason'
			lastName = 'Bourne'
		])
		db.save( new Address => [
			street = 'Bourbon street'
			houseNr = 1
			occupants = #[ person1, person2 ]
		])
		val results = db.query(Address.Data)
			.list
		println(results.size) // returns 1
		println(results.head.street) // returns 'Bourbon street'
		println(results.head.occupants.toList) // no results?
	}
	
}
