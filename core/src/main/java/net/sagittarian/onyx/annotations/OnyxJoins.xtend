package net.sagittarian.onyx.annotations

import com.onyx.persistence.annotations.Relationship
import java.util.List
import net.sagittarian.onyx.metadata.Join
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.TypeReference

import static com.onyx.persistence.annotations.RelationshipType.*

@Active(OnyxJoinsProcessor)
annotation OnyxJoins {

	int maxJoinDepth = 5
	
}

class OnyxJoinsProcessor extends AbstractClassProcessor {
	
	val static FIELD_CLASS_NAME = 'Data'
	
	override doTransform(MutableClassDeclaration cls, extension TransformationContext context) {
		
		// check that @OnyxFields is first
		
		// find the annotation
		val annotation = cls.findAnnotation(OnyxJoins.newTypeReference.type)
		val maxJoinDepth = annotation.getIntValue('maxJoinDepth')
		
		// find the metadata class
		val metaCls = cls.declaredClasses.findFirst [ simpleName == FIELD_CLASS_NAME ]
		if(metaCls === null) { cls.addError('Could not find meta data class') return; }
		
		val relationshipAnnotation = Relationship.newTypeReference
		// val currentCls = findTypeGlobally(metaCls.qualifiedName).newTypeReference

		val relationships = cls.declaredFields.filter [ findAnnotation(relationshipAnnotation.type) !== null ]
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
			if(relationshipType === null) relationship.addError('Could not determine type of relationship ' + relationship.simpleName)
			addJoins(cls, metaCls, #[type -> relationship.simpleName], maxJoinDepth, context)
		}
	}
	
	/*
		public Join<String> addresses_street() {
			return new Join<String>(String.class, "addresses.street");
		}
	 */

	def void addJoins(MutableClassDeclaration cls, MutableClassDeclaration metaCls, List<Pair<TypeReference, String>> path, int depth, extension TransformationContext context) {
		if(depth == 0) return;
		
		val currentType = path.last.key
		val metaTypeName = currentType + '.' + FIELD_CLASS_NAME 
		val currentTypeMeta = findTypeGlobally(metaTypeName)?.newTypeReference
		
		if(currentTypeMeta === null) {
			cls.addError('cannot find meta type ' + metaTypeName + ' for class ' + currentType)
			return;
		}

		val underscorePath = path.map [ value ].join('_')
		val dotPath = path.map [ value ].join('.')

		val relationshipFieldType = net.sagittarian.onyx.metadata.Relationship.newTypeReference
		val joinFieldType = Join.newTypeReference
		val methods = currentTypeMeta
			.declaredResolvedMethods
			.map [ declaration ]
			.filter [ returnType.type.simpleName != joinFieldType.simpleName ]

		for(method : methods) {
			val type = method.returnType.actualTypeArguments.head
			val name = underscorePath + '_' + method.simpleName
			if(method.returnType.type.simpleName == relationshipFieldType.simpleName) {
				val inPath = path.findFirst [ value == method.simpleName ] !== null
				// it is a relationship. recurse into it to add the relationship target fields as well
				if(!inPath) { //  && metaCls.containsMethod(name)
					val newPath = (path + #[type -> method.simpleName]).toList
					addJoins(cls, metaCls, newPath, depth - 1, context)
				}
			} else {
				// it is a property, add it as a relationship join
				val join = dotPath + '.' + method.simpleName
				if(metaCls.containsMethod(name)) {
					metaCls.addMethod(name) [
						returnType = Join.newTypeReference(type)
						body = '''return new «returnType»(«type».class, "«join»");'''
					]
				}
			}
		}
		
	}
	
	def static boolean containsMethod(MutableClassDeclaration cls, String methodName) {
		cls.declaredMethods.findFirst [ simpleName == methodName && parameters.size == 0 ] === null
	}
	
}


