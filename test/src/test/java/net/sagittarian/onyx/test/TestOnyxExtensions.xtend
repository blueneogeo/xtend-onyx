package net.sagittarian.onyx.test

import com.onyx.persistence.factory.PersistenceManagerFactory
import com.onyx.persistence.factory.impl.CacheManagerFactory
import com.onyx.persistence.manager.PersistenceManager
import com.onyx.persistence.query.Query
import com.onyx.query.QueryListener
import net.sagittarian.onyx.test.entities.Address
import net.sagittarian.onyx.test.entities.Person
import org.junit.After
import org.junit.Assert
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

	int listeningAddCount = 0
	
	@Test
	def void testListening() {

		val query = new Query(Person)
		
		query.changeListener = new QueryListener<Person> {
			
			override onItemAdded(Person item) {
				listeningAddCount++
			}
			
			override onItemRemoved(Person item) {
			}
			
			override onItemUpdated(Person item) {
			}
			
		}
		db.executeQuery(query)

		for(i : 1..50) {
			val person = new Person => [ firstName = 'Hello' lastName = 'World' ]
			db.save(person)
		}
		
		Assert.assertEquals(50, listeningAddCount)
		
		db.removeChangeListener(query)
	}


	int observingAddCount = 0

	/**
	 * Add an observer and keep observing add operations until we stop observing at the end.
	 * Notice that we need to assign the personObserver from the builder.observe [ ]
	 * closure so we have a reference to close with.
	 */
	@Test
	def void testObservingUntilEnd() {

		val listener = db
			.query(Person.Data)
			.listen(new QueryListener<Person> {
				
				override onItemAdded(Person item) {
					observingAddCount++
				}
				
				override onItemRemoved(Person item) {
				}
				
				override onItemUpdated(Person item) {
				}
				
			})

		for(i : 1..50) {
			val person = new Person => [ firstName = 'Hello' lastName = 'World' ]
			db.save(person)
		}

		Assert.assertEquals(50, observingAddCount)
		listener.stopListening
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
