xtend-onyx
==========

This thin library adds a small xtend DSL for querying the [Onyx Database](https://www.onyxdevtools.com/learn/tutorials/index).

It has the following features:

- simple query syntax with boolean operators
- type-safe static compile time query checks
- since it is static, in an IDE you get code completion for fields
- and since it is static, if your model changes, your queries break and can be corrected
- support for joins across your entities

# Table of Contents

  * [xtend\-onyx](#xtend-onyx)
  * [Table of Contents](#table-of-contents)
  * [Example](#example)
  * [Getting Started](#getting-started)
    * [Gradle commands](#gradle-commands)
    * [In your own project](#in-your-own-project)
  * [Setting up entities](#setting-up-entities)
    * [@OnyxFields](#onyxfields)
    * [@OnyxJoins](#onyxjoins)
  * [Querying entities](#querying-entities)
    * [Creating the builder](#creating-the-builder)
    * [Using where](#using-where)
    * [Using order](#using-order)
  * [Getting results](#getting-results)
    * [As a List](#as-a-list)
    * [As a lazy List](#as-a-lazy-list)
    * [A list of selected fields](#a-list-of-selected-fields)
    * [The first result](#the-first-result)
    * [Limiting results](#limiting-results)
  * [Updating entities](#updating-entities)
    * [Setting new values](#setting-new-values)
  * [Deleting entities](#deleting-entities)

# Example

```xtend
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
	.query (Person.Data)
	.where [ firstName != null && address_houseNr == 99 ]
	.order [ -id ]
	.list

println(results)
```

# Getting Started

## Gradle commands

This project uses Gradle. In the project root, type:

- *gradle build* - To build the project and run a test.
- *gradle eclipse* - To generate the Eclipse projects to import.
- *gradle idea* - To generate the IntelliJ IDEA projects to import.
- *gradle install* - To install the library on your local maven repository.

## In your own project

Xtend-onyx has only dependencies on the standard xtend java library and the onyx database.

It is not yet available on Maven Central, so to use it you have to install it to your local repository.

To import it after you have gradle installed it locally (see above), add this dependency to your own project:

	compile "net.sagittarian.xtend-onyx-core:1.0"

and add the Onyx database dependency as well, eg:

	compile "com.onyxdevtools:onyx-database:$onyxVersion"

# Setting up entities

Annotate your every **ManagedEntity** class with:

```xtend
@OnyxFields
@OnyxJoins
```

This will make the metadata from your entity statically available to the xtend-onyx library.

## @OnyxFields

This Active Annotation will add the **Data** subclass to your entity. This **Data** class contains field and relationship methods, based on the ManagedEntity annotations. It is an implementation of the **MetaData<T>** interface.

## @OnyxJoins

This Active Annotation must always be placed *after* @OnyxFields. It will navigate through the relationships between your entities and for each relationship field found, it will add a join method to the **Data** class.

# Querying entities

## Creating the builder

These methods can be used in a **TypedQueryBuilder**. This builder builds an Onyx Query. This is used in combination with the OnyxExtensions static extensions. This extension class provides the **query(PersistenceManager, MetaData<T>)** method, that creates a **TypedQueryBuilder** instance to work with.

For example:

```xtend
val builder = db.query(Person.Data)
```

This builder can be given query commands to filter entities, such as:

	.select
	.where
	.order

After setting these properties as well as others, you can call .build too generate the Onyx Query. However, unless you want to re-use an Onyx Query object, you will normally directly call one of the following:

	.list
	.lazyList
	.first
	.update
	.delete

Below is an explanation of how to use each of the operations the builder provides.

## Using where

Lets you filter the stored entities with query criteria.

```xtend
query.where( (Metadata<T>)=>QueryCriteria )
```

The metadata instance provides you with the field and join selectors, and the extension provides you with handy overloads that let you create criteria with these selectors. For example:

	selector == value

This translates to new QueryCritera(selector.name, EQUALS_TO, value). Similar overloads exist for the following operators: **!= > >= < <=**.

Example:

```xtend
db
	.query (Address.Data)
	.where [ street == 'Busystreet' && houseNr >= 20 ]
```

If you use where multiple times on a query, it will perform a logical AND between all of your criteria. This has the same result as the query above:

```xtend
db
	.query (Address.Data)
	.where [ street == 'Busystreet' ]
	.where [ houseNr >= 20 ]
```

The @OnyxJoin annotation also lets you use join selectors in queries. For example, given an Address class with a relationship *occupants* of type Person, and each Person entity having a firstName, you can do this:

```xtend
db
	.query (Address.Data)
	.where [ occuptants_firstName == 'Jason' ]
```

You can check if an attribute is one of a list of attributes using selector.in() :

```xtend
	// directly specify
	query.where [ name.in('Josh', 'Mary', 'John') ]
	
	// or as a list:
	val wantedPeople = #['Josh', 'Mary', 'John']
	query.where [ name.in(wantedPeople) ]
	
	// everyone but those people:
	query.where [ name.notIn(wantedPeople) ]
```

Using selector.in() can work particulary well with enum types.

There are also these additional string field operations:

```xtend
	// positive expressions
	selector.startsWith(text) // field value must start with the text
	selector.contains(text) // field value must contain this text
	selector.matches(regexp) // field value matches the regular expression

	// negative versions of the above
	selector.notStartsWith(text)text
	selector.notContains(text)
	selector.notMatches(regexp)	
```

## Using order

Lets you change the order of the returned entities.

```xtend
.order( (Metadata<T>)=>QueryOrder … )
```

The metadata instance provides you with the field and join selectors, and the extension provides you with handy overloads that let you create QueryOrder instances for these selectors. For example:

	+selector // order by the selector in increasing order
	-selector // order by the selector in decreasing order

You can call order multiple times, or pass multiple closures.

Examples:

```xtend
db
	.query (Address.Data)
	.where [ street == 'Busystreet' && houseNr >= 20 ]
	.order [ +street ]
```

To sort first by street ascending, and then houseNr descending:

```xtend
db
	.query (Address.Data)
	.where [ street == 'Busystreet' && houseNr >= 20 ]
	.order [ +street ]
	.order [ -houseNr ]
```

This has the same result:

```xtend
db
	.query (Address.Data)
	.where [ street == 'Busystreet' && houseNr >= 20 ]
	.order ( [ +street ], [ -houseNr ] )
```

# Getting results

## As a List

Get the results of the query as a **List**.

	.list

Example:

```xtend
val results = db
	.query (Address.Data)
	.where [ street == 'Busystreet' && houseNr >= 20 ]
	.order [ +street ]
	.list
println(results) // prints addresses
```

## As a lazy List

This performs the same basic function as List, but only gets the matching results and does not yet hydrate them into full entities. The moment you get something from the list, the entity is actually fetched. This can help query large resultsets.

Unlike the Onyx resulted list, this list can be iterated over normally:

```xtend
val results = db
	.query (Address.Data)
	.lazyList

for(result : results) {
	println(result) // gets and hydrates the result entity
}
```

## A list of selected fields

To tune performance, you can tell Onyx to only fetch the fields you are interested in for each fetched entity.

```xtend
query.list( (MetaData)=>Field<?>… fieldFns )
```

For example, to only fetch the firstName for each entity:

```xtend
val List<String> results = db
	.query (User.Data)
	.list [ firstName ]
```

You can also select multiple fields, in which case you will get a list of map<field, value>.

```xtend
val List<Map<String, ?> results = db
	.query (User.Data)
	.list( [ firstName ], [ lastName ])
```

These selections also work with lazyList:

```xtend
val List<Map<String, ?> results = db
	.query (User.Data)
	.lazyList( [ firstName ], [ lastName ])
```

## The first result

To simply get the first result only, perform .first:

```xtend
println(db.query(Address.Data).first)
```

## Counting results

Get a count of the amount of entities matching your query with .count:

```xtend
// how many addresses do we have?
println(db.query(Address.Data).count) 
```

## Limiting results

There are some properties you can set on the builder to set how to page through results:

- .skip(amount) : skip [amount] results.
- .limit(amount) : at maximum return [amount] results.
- .page(pageNr) : get a single page of results, given an amount of results per page you set with limit. This can also be combined with skip, the paging will then start after the skipped entities.
- .range(first..last) : return only the [first]th to at most the [last]th result. Also combines with skip and limit, in that it will start counting after the skipped entities, and return at most limit entities.

# Updating entities

You update entities by calling .set [ ] to tell the builder what values to set, and then .update to perform the changes.

## Setting new values

Update an entity attribute. Use the => operator to assign a value inside the closure.

```xtend
db
	.query (User.Data)
	.set [ username => 'bobby' ]
	.update // changes all usernames to bobby
```

You can also perform multiple set commands:

```xtend
db
	.query (User.Data)
	.set [ username => 'bobby' ]
	.set [ hobby => 'knitting' ]
	.update
```

Or combine them in a single set:

```xtend
db
	.query (User.Data)
	.set ( [ username => 'bobby' ], [ hobby => 'knitting' ] )
	.update
```

Combine setting with .where [ ] to only change some entities:

```xtend
db
	.query (User.Data)
	.set [ username => 'bobby' ]
	.where [ username == 'robby' ]
	.update // changes robby user to bobby
```

The update call returns the amount of entities that were updated.

# Deleting entities

End a query with .delete to remove all entities that match the query.

```xtend
db
	.query (User.Data)
	.delete // deletes all users

db
	.query (User.Data)
	.where [ username == 'robby' ]
	.delete // deletes robby
```

The delete call returns the amount of entities that were removed.
