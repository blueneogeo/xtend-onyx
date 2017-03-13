xtend-onyx
==========

This thin library adds a small xtend DSL for querying Onyx.

It has the following features:

- simple syntax with boolean operators
- type-safe static compile time query checks
- since it is static, in an IDE you get code completion for fields
- and since it is static, if your model changes, your queries break and can be corrected
- support for joins

# Example:

	import static extension nl.kii.onyx.OnyxExtensions.*
	
	val db = factory.persistenceManager
	
	val person = new Person => [
		firstName = 'Foo'
		lastName = 'Bar'
		address = new Address => [
			street = 'FooStreet'
			houseNr = 99
		]
	]
	
	db.saveEntity(person)
	
	val results = db
		.from(Person.Data)
		.where [ firstName != null && address_houseNr == 99 ]
		.order [ -id ]
		.list
		
	println(results)

# Getting Started

This project uses Gradle. In the project root, type:

- *gradle build* - To build the project and run a test.
- *gradle eclipse* - To generate the Eclipse projects to import.
- *gradle idea* - To generate the IntelliJ IDEA projects to import.

# Usage

Annotate every **ManagedEntity** with:

	@OnyxFields
	@OnyxJoins

## @OnyxFields

This Active Annotation will add the **Data** subclass to your entity. This **Data** class contains field and relationship methods, based on the ManagedEntity annotations. It is an implementation of the **MetaData<T>** interface.

## @OnyxJoins

This Active Annotation must always be placed *after* @OnyxFields. It will navigate through the relationships of the entities and for each relationship field found, it will add a method to the **Data** class added by the @OnyxFields annotation.

## From

These methods can be used in a **TypedQueryBuilder**. This builder builds an Onyx Query. This is used in combination with the OnyxExtensions static extensions. This extension class provides the **from(PersistenceManager, MetaData<T>)** method, that creates a **TypedQueryBuilder** instance to work with.

For example:

	val builder = db.from(Person.Data)

This class provides the following query functions:

## Where

Lets you filter the stored entities with query criteria.

	.where( (Metadata<T>)=>QueryCriteria )

The metadata instance provides you with the field and join selectors, and the extension provides you with handy overloads that let you create criteria with these selectors. For example:

	selector == value

This translates to new QueryCritera(selector.name, EQUALS_TO, value). Similar overloads exist for the following operators: **!= > >= < <=**.

Example:

	db
		.from(Address.Data)
		.where [ street == 'Busystreet' && houseNr >= 20 ]

The @OnyxJoin annotation also lets you use join selectors in queries. For example, given an Address class with a relationship *occupants* of type Person, and each Person entity having a firstName, you can do this:

	db
		.from(Address.Data)
		.where [ occuptants_firstName == 'Jason' ]

## Order

Lets you change the order of the returned entities.

	.order( (Metadata<T>)=>List<QueryOrder> )

The metadata instance provides you with the field and join selectors, and the extension provides you with handy overloads that let you create QueryOrder instances for these selectors. For example:

	+selector // order by the selector in increasing order
	-selector // order by the selector in decreasing order

You can combine these query orders with &&.

Example:

	db
		.from(Address.Data)
		.where [ street == 'Busystreet' && houseNr >= 20 ]
		.order [ +street && +houseNr ] // order first by street and then housenr

## List

Get the results of the query as a **List**.

	.list

Example:

	val results = db
		.from(Address.Data)
		.where [ street == 'Busystreet' && houseNr >= 20 ]
		.order [ +street && +houseNr ]
		.list
	println(results) // prints addresses
