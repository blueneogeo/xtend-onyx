package net.sagittarian.onyx.annotations

import com.onyx.persistence.annotations.Attribute
import com.onyx.persistence.annotations.Relationship
import net.sagittarian.onyx.metadata.Field
import net.sagittarian.onyx.metadata.MetaData
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.RegisterGlobalsContext
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.ClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration

import static com.onyx.persistence.annotations.RelationshipType.*

@Active(OnyxFieldsProcessor)
annotation OnyxFields {
	
}

class OnyxFieldsProcessor extends AbstractClassProcessor {
	
	val static FIELD_CLASS_NAME = 'Data'
	
	override doRegisterGlobals(extension ClassDeclaration cls, extension RegisterGlobalsContext context) {
		registerClass(cls.qualifiedName + '.' + FIELD_CLASS_NAME)
	}

	override doTransform(MutableClassDeclaration cls, extension TransformationContext context) {
		
		val relationshipAnnotation = Relationship.newTypeReference 
		
		// find the metadata class
		val metaCls = cls.declaredClasses.findFirst [ simpleName == FIELD_CLASS_NAME ]
		
		// implement the interface
		metaCls.implementedInterfaces = metaCls.implementedInterfaces + #[MetaData.newTypeReference(cls.newTypeReference)]
		metaCls.addMethod('getEntityType') [
			returnType = Class.newTypeReference(cls.newTypeReference)
			body = '''return «cls».class;'''
		]

		// find the attribute fields		
		val attributes = cls.declaredFields.filter [ 
			findAnnotation(Attribute.newTypeReference.type) !== null
		]

		// add the fields to the metadata cls
		for(attribute : attributes) {
			// create a non-static getter method with the name of the field
			metaCls.addMethod(attribute.simpleName) [
				primarySourceElement = attribute
				returnType = Field.newTypeReference(attribute.type)
				body = '''return new «Field»(«attribute.type».class, "«attribute.simpleName»");'''
			]
		}

		// find the relationship fields		
		val relationships = cls.declaredFields.filter [ 
			findAnnotation(relationshipAnnotation.type) !== null
		]

		// add the relationships to the metadata cls
		for(relationship : relationships) {
			val relationshipType = relationship
				.findAnnotation(relationshipAnnotation.type)
				.getEnumValue('type')
				.simpleName
			val type = switch relationshipType {
				case ONE_TO_MANY.name: relationship.type.actualTypeArguments.head 
				case MANY_TO_MANY.name: relationship.type.actualTypeArguments.head
				case ONE_TO_ONE.name: relationship.type
				case MANY_TO_ONE.name: relationship.type
			}
			val fieldType = net.sagittarian.onyx.metadata.Relationship.newTypeReference(type) 
			metaCls.addMethod(relationship.simpleName) [
				primarySourceElement = relationship
				returnType = fieldType
				body = '''return new «fieldType»(«type».class, "«relationship.simpleName»");'''
			]
		}
	}
	
}



