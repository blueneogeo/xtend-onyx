# How it works

The **TypedQuery** you create with xtend-onyx is a builder for a normal Onyx query. You need to pass it the meta-data you are querying. This meta-data is auto-generated on your entities by adding the **OnyxFields** and **OnyxJoins** active annotations.

Lets take this entity class: 

```xtend
@OnyxFields // creates the Person.Data inner class with field and relationship metadata
@OnyxJoins // adds the joins to the Data class
@Accessors // generates getters and setters
@Entity // marks as an Onyx entity
class Person extends ManagedEntity {

	@Identifier(generator=SEQUENCE)
	@Attribute
	Long id

	@Attribute
	String firstName

	@Attribute
	String lastName

	@Relationship(type=MANY_TO_ONE, inverseClass=Address, inverse='occupants', cascadePolicy=ALL)
	Address address

}
```

## @OnyxFields

This Active Annotation will add the **Data** subclass to your entity. This **Data** class contains field and relationship methods, based on the ManagedEntity annotations. It is an implementation of the **MetaData<T>** interface.

In the above example, the **@OnyxFields** annotation will add a Person.Data subclass. This subclass will contain methods with the names of the fields and relationships, that return **Field<T>** and **Relationship<T>**.

For example, the *firstname* attribute in the class with add this to Person.Data:

```java
public Field<String> firstName() {
	return new Field(String.class, "firstName");
}
```

and the relationship *address* will add this method to Person.Data:

```java
public Relationship<Address> address() {
	return new Relationship<Address>(Address.class, "address");
}
```

## @OnyxJoins

This Active Annotation must always be placed *after* @OnyxFields. It will navigate through the relationships between your entities and for each relationship field found, it will add a join method to the **Data** class.

Let us say that Address has a street and a houseNr attribute. Since Person has an Address relationship, these fields would be added to Person.Data as joins:

```java
public Join<String> address_street() {
  return new Join<String>(String.class, "address.street");
}

public Join<Integer> address_houseNr() {
  return new Join<Integer>(Integer.class, "address.houseNr");
}
```

## OnyxExtensions operator overloads

You use these generated method when you do your querying. The *Field*, *Relationship* and *Join* classes are all implementations of *Selector*. A *Selector* always has a name and a type.

For example, lets break down what happens when you do this:

```xtend
db.query(Person.Data)
	.set [ firstName => 'Tester' ]
	.where [ address_street = 'somestreet' && age > 20 ]
	.update
```

### Creating the query

Performing:

	db.query(Person.Data)

This calls this method: 

```xtend
def static <T extends ManagedEntity, M extends MetaData<T>> TypedQuery<T, M> query(PersistenceManager session, Class<M> metaDataType) {
	new TypedQuery(session, metaDataType)
}
```

It simply creates a new **TypedQuery** for your session. Note that you need to pass not the entity type, but the entity **MetaData** type. This is because the metadata refers to the entity, and we need the metadata to have access to the selectors.

### Setting the update values

Performing:

	.set [ firstName => 'Tester' ]

Calls this method:

```xtend
def TypedQuery<T, M> set((M)=>AttributeUpdate<?>... updateFns) 
```

The (M)=>AttributeUpdate<?> means it requires a function to be passed that returns an **AttributeUpdate**. That is a standard Onyx update instruction. The trick here is that you can create this using the **OnyxExtensions.=>()** operator overload method:

```xtend
def static =>(Field<String> selector, String value) {
	new AttributeUpdate(selector.name, value)
}
```

There is one of these for every Onyx supported field type. This one takes a **Field<String>** and assigns it a value. The result is an **AttributeUpdate**. This sounds complicated, but it actually just an assignment, eg:

```xtend
val personData = new Person.Data
val attributeUpdate = personData.firstName => 'Tester'
```

Since the **.set** method from before passes in the closure the personData, we can do this:

```xtend
query.set [ firstName => 'Tester' ]
```

### Passing the criteria

TODO: write

