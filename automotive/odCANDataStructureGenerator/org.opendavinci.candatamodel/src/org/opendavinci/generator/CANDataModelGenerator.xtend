/**
 * CANDataStructureGenerator - IDL tool to describe the mapping from
 *                             CAN data to high-level messages.
 * Copyright (C) 2015 Christian Berger
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package org.opendavinci.generator

import java.util.ArrayList
import java.util.HashMap
import java.util.Iterator
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.opendavinci.canDataModel.CANSignal
import org.opendavinci.canDataModel.CANSignalMapping
import java.util.Random
import org.opendavinci.canDataModel.Mapping
import org.opendavinci.canDataModel.CANSignalTesting

class CANDataModelGenerator implements IGenerator {

	/* This class describes all data to a defined CAN signal in a .can file. */
	static class CANSignalDescription {
		String m_FQDN
		String m_CANID
		String m_startBit
		String m_length
		String m_lengthBytes
		String m_endian
		String m_multiplyBy
		String m_add
		String m_rangeStart
		String m_rangeEnd
	}
	
    /* This method is our interface to an outside caller. */
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val generatedHeadersFile = resource.URI.toString().substring(resource.URI.toString().lastIndexOf("/") + 1).replaceAll(".can", "")

		// First, extract all CAN signals from .can file.
		val mapOfDefinedCANSignals = collectDefinedCANSignals(resource.allContents.toIterable.filter(typeof(CANSignal)))
		
		// needed for the "super" header and source files
		var ArrayList<String> includedClasses=new ArrayList<String>
		for (e : resource.allContents.toIterable.filter(typeof(CANSignalMapping))) {
			includedClasses.add(e.mappingName.toString().replaceAll("\\.", "/"))
		}
		
		fsa.generateFile("include/GeneratedHeaders_" + generatedHeadersFile + ".h", generateSuperHeaderFileContent(generatedHeadersFile, includedClasses))
		fsa.generateFile("src/GeneratedHeaders_" + generatedHeadersFile + ".cpp", generateSuperImplementationFileContent(generatedHeadersFile, includedClasses))
		
		var ArrayList<CANSignalTesting> tests=new ArrayList<CANSignalTesting>(resource.allContents.toIterable.filter(typeof(CANSignalTesting)).toList);
		
		// Next, generate the code for the actual mapping.
		for (e : resource.allContents.toIterable.filter(typeof(CANSignalMapping))) {
			fsa.generateFile("include/generated/" + e.mappingName.toString().replaceAll("\\.", "/") + ".h", generateHeaderFileContent(generatedHeadersFile, e))
			fsa.generateFile("src/generated/" + e.mappingName.toString().replaceAll("\\.", "/") + ".cpp", 
				generateImplementationFileContent(e, "generated", mapOfDefinedCANSignals))
			fsa.generateFile("testsuites/" + e.mappingName.toString().replaceAll("\\.", "_") + "TestSuite.h", generateTestSuiteContent(generatedHeadersFile, e, tests, mapOfDefinedCANSignals))
			fsa.generateFile("uppaal/generated/" + e.mappingName.toString().replaceAll("\\.", "/"), generateUPPAALFileContent(e, mapOfDefinedCANSignals))
		}
	}

	/* This method collects all CAN signal definitions. */
	def collectDefinedCANSignals(Iterable<CANSignal> iter) {
		val cansignalsByFQDN =  new HashMap<String, CANSignalDescription>
		val localIterator = iter.iterator
		while (localIterator.hasNext) {
			val cs = localIterator.next
			val csd = new CANSignalDescription
			csd.m_FQDN = cs.cansignalname
			csd.m_CANID = cs.canIdentifier
			csd.m_startBit = cs.startBit
			csd.m_length = cs.length
			if((cs.length==null || cs.length=="") && (cs.lengthBytes!=null || cs.lengthBytes!=""))
				csd.m_length = (Integer.parseInt(cs.lengthBytes)*8)+""
			csd.m_lengthBytes = cs.lengthBytes
			if((cs.lengthBytes==null || cs.lengthBytes=="") && (cs.length!=null || cs.length!="") && Integer.parseInt(cs.length)%8==0)
				csd.m_lengthBytes = (Integer.parseInt(cs.length)/8)+""
			csd.m_endian = cs.endian
			csd.m_multiplyBy = cs.multiplyBy
			csd.m_add = cs.add
			csd.m_rangeStart = cs.rangeStart
			csd.m_rangeEnd = cs.rangeEnd
			cansignalsByFQDN.put(csd.m_FQDN, csd)
		}
        return cansignalsByFQDN
	}

    /* This method generates the header file content. */
	def generateSuperHeaderFileContent(String generatedHeadersFile, ArrayList<String> includedClasses) '''
/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */

#ifndef GENERATEDHEADERS_«generatedHeadersFile.toUpperCase()»_H_
#define GENERATEDHEADERS_«generatedHeadersFile.toUpperCase()»_H_

#include <string>
#include <vector>

«FOR include : includedClasses»
#include "generated/«include».h"
«ENDFOR»

#include <core/data/Container.h>

#include "GeneratedHeaders_AutomotiveData.h"

namespace canmapping {

    using namespace std;

    class CanMapping {
        private:
            /**
             * "Forbidden" copy constructor. Goal: The compiler should warn
             * already at compile time for unwanted bugs caused by any misuse
             * of the copy constructor.
             *
             * @param obj Reference to an object of this class.
             */
            CanMapping(const CanMapping &/*obj*/);

            /**
             * "Forbidden" assignment operator. Goal: The compiler should warn
             * already at compile time for unwanted bugs caused by any misuse
             * of the assignment operator.
             *
             * @param obj Reference to an object of this class.
             * @return Reference to this instance.
             */
            CanMapping& operator=(const CanMapping &/*obj*/);

        public:
            CanMapping();

            virtual ~CanMapping();

            /**
             * This method adds the given GenericCANMessage to the internal
             * CAN message decoder. If this message could be decoded (or
             * including the previous sequence, this method returns a valid
             * Container (ie. Container::UNDEFINEDDATA).
             *
             * @param gcm Next GenericCANMessage.
             * @return Container, where the type needs to be checked to determine invalidity (i.e. !Container::UNDEFINEDDATA).
             */
            vector<core::data::Container> mapNext(const ::automotive::GenericCANMessage &gcm);

        private:
        
			«FOR include : includedClasses»
			«var String className=include.split('\\/').get(include.split('\\/').size-1)»
				«include.replaceAll('\\/','::')» m_«Character.toLowerCase(className.charAt(0)) + className.substring(1)»;
			«ENDFOR»
		
    };

} // canmapping

#endif /*GENERATEDHEADERS_«generatedHeadersFile.toUpperCase()»_H_*/
'''

    /* This method generates the header file content. */
	def generateSuperImplementationFileContent(String generatedHeadersFile, ArrayList<String> includedClasses) '''
/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */

«FOR include : includedClasses»
#include "generated/«include».h"
«ENDFOR»

#include "GeneratedHeaders_«generatedHeadersFile».h"

namespace canmapping {


«var ArrayList<String> members=new ArrayList<String>»
«var Iterator<String> iter = includedClasses.iterator»
«{var String member;
	while (iter.hasNext()){
	member=iter.next();
	var String className=member.split('\\/').get(member.split('\\/').size-1)
	var String temp="m_"+Character.toLowerCase(className.charAt(0)) + className.substring(1)+" ()";
	if(iter.hasNext())temp+=",";
	members.add(temp);
}}»
    CanMapping::CanMapping() :
    «FOR member:members»
    «member»
    «ENDFOR»
{}

    CanMapping::~CanMapping() {}

    vector<core::data::Container> CanMapping::mapNext(const ::automotive::GenericCANMessage &gcm) {
        vector<core::data::Container> listOfContainers;

        // Traverse all defined mappings and check whether a new high-level message could be fully decoded.
	    «FOR member:members»
	    {
	    	core::data::Container container = «member.substring(0,member.indexOf(" ()"))».decode(gcm);
	    	if (container.getDataType() != core::data::Container::UNDEFINEDDATA)
	    	{
	    		listOfContainers.push_back(container);
	    	}
	    }
	    «ENDFOR»

        return listOfContainers;
    }

} // canmapping
'''

	def generateHeaderFileBody(String className, CANSignalMapping mapping) '''
    using namespace std;

    class «className» : public core::data::SerializableData, public core::base::Visitable {
        private:
            /**
             * "Forbidden" copy constructor. Goal: The compiler should warn
             * already at compile time for unwanted bugs caused by any misuse
             * of the copy constructor.
             *
             * @param obj Reference to an object of this class.
             */
            «className»(const «className» &/*obj*/);

            /**
             * "Forbidden" assignment operator. Goal: The compiler should warn
             * already at compile time for unwanted bugs caused by any misuse
             * of the assignment operator.
             *
             * @param obj Reference to an object of this class.
             * @return Reference to this instance.
             */
            «className»& operator=(const «className» &/*obj*/);

        public:
            «className»();

		«IF mapping.mappings.size>0»
		«var ArrayList<String> parameters=new ArrayList<String>»
		«var Iterator<Mapping> iter = mapping.mappings.iterator»
		«{
			while (iter.hasNext()){
				iter.next();
				var String temp="double";
				if(iter.hasNext())temp+=", ";
				parameters.add(temp);
			}
		}»
		«className»(«FOR parameter:parameters»«parameter»«ENDFOR»);
		«ENDIF»

            virtual ~«className»();

            core::data::Container decode(const ::automotive::GenericCANMessage &gcm);
            
«var ArrayList<String> capitalizedNames=new ArrayList<String>»
«{
			var String[] chunks
			var String capitalizedName
			for(currenMapping : mapping.mappings){
				chunks=currenMapping.cansignalname.split('\\.');
				capitalizedName=""
				for(chunk:chunks){
					capitalizedName+=chunk.toFirstUpper
				}
				capitalizedNames+=capitalizedName
			}
	}»
        	«FOR capitalizedName : capitalizedNames»
        	double get«capitalizedName»() const;
        	void set«capitalizedName»(const double&);
        	
        	«ENDFOR»

            virtual const string toString() const;
    
    		virtual ostream& operator<<(ostream &out) const;
    
    		virtual istream& operator>>(istream &in);

    		virtual void accept(core::base::Visitor &v);
    		
        private:
        	«FOR capitalizedName : capitalizedNames»
        	double m_«capitalizedName.toFirstLower»;
        	«ENDFOR»
        	
        	std::map<uint64_t,uint64_t> m_payloads;
        	std::vector<uint64_t> m_neededCanMessages;
        	uint64_t m_index;
    }; // end of class "«className»"
    
	'''

	def generateHeaderFileNSs(String[] namespaces, int i, CANSignalMapping mapping) '''
	«IF namespaces.size>i+1»
	namespace «namespaces.get(i)» {
		«generateHeaderFileNSs(namespaces, i+1, mapping)»
	} // end of namespace "«namespaces.get(i)»"
	«ELSE»
	«generateHeaderFileBody(namespaces.get(i), mapping)»
	«ENDIF»
	'''

    /* This method generates the header file content. */
	def generateHeaderFileContent(String generatedHeadersFile, CANSignalMapping mapping) '''
/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */
// Header file for: «mapping.mappingName.toString»
#ifndef «mapping.mappingName.toString.toUpperCase.replaceAll("\\.", "_")»_H_
#define «mapping.mappingName.toString.toUpperCase.replaceAll("\\.", "_")»_H_

#include <vector>
#include <core/data/Container.h>
#include <core/base/Visitable.h>
#include <core/data/SerializableData.h>

#include "GeneratedHeaders_AutomotiveData.h"

namespace canmapping {
	«var String[] classNames = mapping.mappingName.toString.split('\\.')»
	«IF classNames.size>1»
		«generateHeaderFileNSs(classNames, 0, mapping)»
	«ELSE»
		«generateHeaderFileBody(classNames.get(0), mapping)»
	«ENDIF»
} // end of namespace canmapping

#endif /*«mapping.mappingName.toString.toUpperCase.replaceAll("\\.", "_")»_H_*/
'''

	def generateImplementationFileNSs(String[] namespaces, int i, CANSignalMapping mapping, String includeDirectoryPrefix, HashMap<String, CANSignalDescription> canSignals, ArrayList<String> canIDs) '''
	«IF namespaces.size>i+1»
	namespace «namespaces.get(i)» {
		«generateImplementationFileNSs(namespaces, i+1, mapping, includeDirectoryPrefix, canSignals, canIDs)»
	} // end of namespace "«namespaces.get(i)»"
	«ELSE»
	«generateImplementationFileBody(namespaces.get(i), mapping, includeDirectoryPrefix, canSignals, canIDs)»
	«ENDIF»
	'''
	
	def generateImplementationFileBody(String className, CANSignalMapping mapping, String includeDirectoryPrefix, HashMap<String, CANSignalDescription> canSignals, ArrayList<String> canIDs) '''
	
	using namespace std;

«var ArrayList<String> capitalizedNames=new ArrayList<String>»
«{
			var String[] chunks
			var String capitalizedName
			for(currenMapping : mapping.mappings){
				chunks=currenMapping.cansignalname.split('\\.');
				capitalizedName=""
				for(chunk:chunks){
					capitalizedName+=chunk.toFirstUpper
				}
				capitalizedNames+=capitalizedName
			}
	}»

	«className»::«className»() :
		core::data::SerializableData(),
		core::base::Visitable(),
		«FOR capitalizedName : capitalizedNames»
		m_«capitalizedName.toFirstLower»(0.0),
		«ENDFOR»
		m_payloads(),
		m_neededCanMessages(),
		m_index(0)
	{
		«FOR id : canIDs»
		m_neededCanMessages.push_back(«id»);
        «ENDFOR»
	}
	
	«IF mapping.mappings.size>0»
	«var ArrayList<String> parameters=new ArrayList<String>»
	«var ArrayList<String> initializations=new ArrayList<String>»
	«var Iterator<Mapping> iter = mapping.mappings.iterator»
	«{
		var int i=0;
		while (iter.hasNext()){
		iter.next();
		var String temp="double parameter"+(i++);
		if(iter.hasNext())temp+=", ";
		parameters.add(temp);
		}
		i=0;
		for(currenMapping : mapping.mappings){
			var String[] chunks=currenMapping.cansignalname.split('\\.');
			var String capitalizedName=""
			for(chunk:chunks) capitalizedName+=chunk.toFirstUpper
			initializations.add("m_"+capitalizedName.toFirstLower+"(parameter"+(i++)+")");
		}
		}»
	«className»::«className»(«FOR parameter:parameters»«parameter»«ENDFOR») :
		core::data::SerializableData(),
		core::base::Visitable(),
		«FOR initialization:initializations»«initialization+","+'\n'»«ENDFOR»
		m_payloads(),
		m_neededCanMessages(),
		m_index(0)
	{
		«FOR id : canIDs»
		m_neededCanMessages.push_back(«id»);
        «ENDFOR»
	}
	«ENDIF»
	
	«className»::~«className»() {}
	
    	«var String result="\"Class : "+className+"\"<<endl"+'\n'»
    	«var int fieldsNum=mapping.mappings.size»
    	«IF fieldsNum>0»
		«var Iterator<Mapping> iter = mapping.mappings.iterator»
		«{var int i=0;
			while (iter.hasNext()){
			iter.next();
			var String[] chunks=mapping.mappings.get(i).cansignalname.split('\\.');
			var String capitalizedName=""
			for(chunk:chunks) capitalizedName+=chunk.toFirstUpper
			result+='\t'+'\t'+"<<\" "+mapping.mappings.get(i).cansignalname.toString+" : \"<< m_"+capitalizedName.toFirstLower+"<<endl";
			i++;
			if(iter.hasNext())result+='\n';
    	}}»
    	«ENDIF»
	const string «className»::toString() const {
		stringstream result;
		result << «result»;
		return result.str();
	}
	
	«FOR capitalizedName : capitalizedNames»
	double «className»::get«capitalizedName»() const{
		return m_«capitalizedName.toFirstLower»;
	}
	
	void «className»::set«capitalizedName»(const double &«capitalizedName.toFirstLower») {
		m_«capitalizedName.toFirstLower»=«capitalizedName.toFirstLower»;
	}

	«ENDFOR»
	
	ostream& «className»::operator<<(ostream &out) const {
		core::base::SerializationFactory& sf = core::base::SerializationFactory::getInstance();
		core::SharedPointer<core::base::Serializer> s = sf.getSerializer(out);

		«IF mapping.mappings.size>0»
		«var ArrayList<String> opOutBody=new ArrayList<String>»
		«for(var int i=0;i<mapping.mappings.size;i++){
			var String capitalizedName
			var String[] chunks=mapping.mappings.get(i).cansignalname.split('\\.');
			capitalizedName=""
			for(chunk:chunks) capitalizedName+=chunk.toFirstUpper
			
			opOutBody+="s->write(static_cast<uint32_t>("+mapping.mappings.get(i).signalIdentifier+"), m_"+capitalizedName.toFirstLower+");"
		}»
		«FOR line:opOutBody»
		«line»
		«ENDFOR»
		«ENDIF»
		return out;
	}
	
	istream& «className»::operator>>(istream &in) {
		core::base::SerializationFactory& sf = core::base::SerializationFactory::getInstance();
		core::SharedPointer<core::base::Deserializer> s = sf.getDeserializer(in);
		
		«IF mapping.mappings.size>0»
		uint32_t id;
		«var ArrayList<String> opInBody=new ArrayList<String>»
		«for(var int i=0;i<mapping.mappings.size;i++){
			var String capitalizedName
			var String[] chunks=mapping.mappings.get(i).cansignalname.split('\\.');
			capitalizedName=""
			for(chunk:chunks) capitalizedName+=chunk.toFirstUpper
			
			opInBody+="id="+mapping.mappings.get(i).signalIdentifier+";"
			opInBody+="s->read(static_cast<uint32_t>(id), m_"+capitalizedName.toFirstLower+");"
		}»
		«FOR line:opInBody»
		«line»
		«ENDFOR»
		«ENDIF»
		return in;
	}
	
	void «className»::accept(core::base::Visitor &v) {
	«IF mapping.mappings.size==0»
	(void)v;
	«ELSE»
	«var ArrayList<String> acceptBody=new ArrayList<String>»
	«for(var int i=0;i<mapping.mappings.size;i++){
			var String capitalizedName
			var String[] chunks=mapping.mappings.get(i).cansignalname.split('\\.');
			capitalizedName=""
			for(chunk:chunks) capitalizedName+=chunk.toFirstUpper
			
			acceptBody+="v.visit(static_cast<uint32_t>("+mapping.mappings.get(i).signalIdentifier+"), "
						+mapping.mappings.get(i).signalIdentifier+", \""
						+mapping.mappings.get(i).cansignalname+"\", \""
						+chunks.get(chunks.size-1)+"\", m_"
						+capitalizedName.toFirstLower+");"
		}»
		«FOR line:acceptBody»
		«line»
		«ENDFOR»
	«ENDIF»
	}
	
	core::data::Container «className»::decode(const ::automotive::GenericCANMessage &gcm) {
		core::data::Container c;
		switch(gcm.getIdentifier())
		{
			// order check should be done here
	    	«FOR id : canIDs»
	    	case «id» : 
	    	
	    	«IF mapping.unordered!=null && mapping.unordered.compareTo("unordered")==0»
	    	// if the order doesn't matter, store the payload in a map for future use replacing the current content held there
	    	m_payloads[gcm.getIdentifier()] = gcm.getData();
	    	«ELSE»
	    	// if the order matters:
	    	if(m_neededCanMessages.at(m_index) == «id») // if we got the expected message
	    	{
	    		// Store the payload in a map for future use replacing the current content
	    		m_payloads[«id»] = gcm.getData();
	    		// modularly increase the internal index
	    		(m_index==m_neededCanMessages.size()-1) ? m_index=0 : ++m_index;
	    	}
	    	else // otherwise
	    	{
	    		// reset the payloads map
	    		while(! m_payloads.empty())
	    			m_payloads.erase(m_payloads.begin());
	    		// reset the internal index
	    		m_index=0;
	    	}
	    	«ENDIF»
	    	break;
	    	
	        «ENDFOR»
	        default : return c; // valid id not found
	    }
	    
		// if we don't have all the needed CAN messages, return 
		if(m_payloads.size()!=m_neededCanMessages.size())
			return c;

		// 1. Create a generic message.
		core::reflection::Message message;
	
		«FOR currenMapping : mapping.mappings»
		«var String signalName=currenMapping.cansignalname»
		// addressing signal «signalName»
		{
			// 2. Get the raw payload.
			uint64_t data = m_payloads[«canSignals.get(signalName).m_CANID»];
	
			// 3. Map uin64_t value to 8 byte uint8_t array.
			//uint8_t payload[8]=reinterpret_cast<uint8_t*>(&data);
	
			«var String tempVarType=""»
			«var String tempVarName="raw_"+signalName.replaceAll("\\.", "_")»
			«var String finalVarName="transformed_"+signalName.replaceAll("\\.", "_")»
			«var String capitalizedName»
			«{
				var String[] chunks=currenMapping.cansignalname.split('\\.');
				capitalizedName=""
				for(chunk:chunks) capitalizedName+=chunk.toFirstUpper
			}»
			«var String memberVarName="m_"+capitalizedName.toFirstLower»
			
			// 4.1 Get raw value from attribute.
			«tempVarType="uint64_t"» «tempVarName»=0x0000000000000000;
			«tempVarName»=data;
			
			// reset left-hand side of bit field
			«tempVarName»=«tempVarName» << «Integer.parseInt(canSignals.get(signalName).m_startBit)»;
			// reset right-hand side of bit field
			«tempVarName»=«tempVarName» >> (64-«canSignals.get(signalName).m_length»);
			
			«IF Integer.parseInt(canSignals.get(signalName).m_length)>=8»
				«IF canSignals.get(signalName).m_endian.compareTo("big")==0»
				// 4.2 Optional: Fix endianness depending on CAN message specification.
					«IF Integer.parseInt(canSignals.get(signalName).m_length)<=16»
					uint16_t temp_cast=static_cast<uint16_t>(«tempVarName»);
					temp_cast=ntohs(temp_cast);
					«tempVarName» = static_cast<uint64_t>(temp_cast);
					«ELSEIF Integer.parseInt(canSignals.get(signalName).m_length)<=32»
					uint32_t temp_cast=static_cast<uint32_t>(«tempVarName»);
					temp_cast=ntohl(temp_cast);
					«tempVarName» = static_cast<uint64_t>(temp_cast);
					«ELSEIF Integer.parseInt(canSignals.get(signalName).m_length)<=64»
					«tempVarName» = ntohll(«tempVarName»);
					«ENDIF»
				«ELSE»
				// 4.2 Endianness doesn't need fixing, skipping this step.
				«ENDIF»
			«ELSE»
				// 4.2 Field too short for endianness adjustment, skipping this step.
			«ENDIF»
	
			// variable holding the transformed value
			double «finalVarName»=static_cast<double>(«tempVarName»);
			
			// 4.3 Apply value transformation (i.e. formula) to map raw value to (physically) meaningful value according to CAN message specification.
			// scaling
			const double SCALE = «canSignals.get(signalName).m_multiplyBy»;
			«finalVarName»=«finalVarName»*SCALE;
			// adding
			const double OFFSET = «canSignals.get(signalName).m_add»;
			«finalVarName»=«finalVarName»+OFFSET;
			
			// clamping
			if(«finalVarName»<«canSignals.get(signalName).m_rangeStart»)
				«finalVarName»=«canSignals.get(signalName).m_rangeStart»;
			else if(«finalVarName»>«canSignals.get(signalName).m_rangeEnd»)
				«finalVarName»=«canSignals.get(signalName).m_rangeEnd»;
			
			«memberVarName»=«finalVarName»;
			
			// 4.4 Create a field for a generic message.
			core::reflection::Field<double> *f = new core::reflection::Field<double>(«memberVarName»);
			f->setLongIdentifier(«canSignals.get(signalName).m_CANID»); // The identifiers specified here must match with the ones defined in the .odvd file!
			f->setShortIdentifier(static_cast<uint8_t>(«canSignals.get(signalName).m_CANID»)); // The identifiers specified here must match with the ones defined in the .odvd file!
			f->setLongName("«canSignals.get(signalName).m_FQDN»");
			f->setShortName("«{var String[] res; res=canSignals.get(signalName).m_FQDN.split("\\."); res.get(res.size-1)}»");
			f->setFieldDataType(coredata::reflection::AbstractField::DOUBLE_T);
			f->setSize(sizeof(«memberVarName»));
	
			// 4.5 Add created field to generic message.
			message.addField(core::SharedPointer<coredata::reflection::AbstractField>(f));
		}
	«ENDFOR»
		// 5. Depending on the CAN message specification, we are either ready here
		// (i.e. mapping one CAN message to one high-level C++ message), or we have
		// to wait for more low-level CAN messages to complete this high-level C++ message.
		// Thus, our state machine would have to store this (incomplete) "message"
		// variable internally to continue decoding later.
		
		{
			// 6. As we are ready here for the given example, we create a visitor to
			// traverse the unnamed message and create a named message (i.e. an instance
			// of a high-level C++ message) to be distributed as a Container.
			core::reflection::MessageToVisitableVisitor mtvv(message);
			
			// 7. Create an instance of the named high-level message.
            «var String HLName= (Character.toLowerCase(mapping.mappingName.toString.charAt(0)) + mapping.mappingName.toString.substring(1)).replaceAll("\\.", "_")»
        «mapping.mappingName.toString.replaceAll("\\.", "::")» «HLName»;
	
			// 8. Letting the high-level message accept the visitor to enter the values.
        «HLName».accept(mtvv);

			// 9. Create the resulting container carrying a valid payload.
			c = core::data::Container(core::data::Container::USER_DATA_9, «HLName»);
		}
		return c;
	}
	'''
	
	/* This method generates the implementation (.cpp). */
	def generateImplementationFileContent(CANSignalMapping mapping, String includeDirectoryPrefix, HashMap<String, CANSignalDescription> canSignals) '''
/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */
// Source file for: «mapping.mappingName.toString»

«var ArrayList<String> canIDs=new ArrayList<String>»
/*
signals of interest:

«IF(mapping.mappings.size>0)»
«FOR currenMapping : mapping.mappings»
«currenMapping.cansignalname»
«ENDFOR»
«ELSE»
none.
«ENDIF»

«FOR currenMapping : mapping.mappings»
«var String signalName=currenMapping.cansignalname»
«var CANSignalDescription canSignal=canSignals.get(signalName)»
«var String[] splittedMN=mapping.mappingName.toString.toLowerCase.split("\\.")»
«IF(splittedMN.get(splittedMN.size-1).compareTo(signalName.split("\\.").get(0).toLowerCase)==0)»
«{
	var boolean test=true;
	for(id:canIDs)
		if(id.compareTo(canSignal.m_CANID)==0)
			test=false;
	if(test)
		canIDs.add(canSignal.m_CANID);
	""
}»
CANID       : «canSignal.m_CANID»
FQDN        : «canSignal.m_FQDN»
startBit    : «canSignal.m_startBit»
length      : «canSignal.m_length»
lengthBytes : «canSignal.m_lengthBytes»
endian      : «canSignal.m_endian»
multiplyBy  : «canSignal.m_multiplyBy»
add         : «canSignal.m_add»
rangeStart  : «canSignal.m_rangeStart»
rangeEnd    : «canSignal.m_rangeEnd»

«ENDIF»
«ENDFOR»
*/

#include "generated/«mapping.mappingName.toString.replaceAll('\\.','/')».h"

#include <core/SharedPointer.h>
#include <core/reflection/Message.h>
#include <core/reflection/MessageToVisitableVisitor.h>
#include <core/base/SerializationFactory.h>
#include <core/base/Serializer.h>
#include <core/base/Deserializer.h>

namespace canmapping {

	«var String[] classNames = mapping.mappingName.toString.split('\\.')»
	«IF classNames.size>1»
		«generateImplementationFileNSs(classNames, 0, mapping, includeDirectoryPrefix, canSignals, canIDs)»
	«ELSE»
		«generateImplementationFileBody(classNames.get(0), mapping, includeDirectoryPrefix, canSignals, canIDs)»
	«ENDIF»

} // canmapping
'''

	// Generate the test suite content (.h).	
	def generateTestSuiteContent(String generatedHeadersFile, CANSignalMapping mapping, ArrayList<CANSignalTesting> canSignalTesting, HashMap<String, CANSignalDescription> canSignals) '''
/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */
// Test suite file for: «mapping.mappingName.toString»
«var ArrayList<String> canIDs=new ArrayList<String>»/*
«FOR currenMapping : mapping.mappings»
«var String signalName=currenMapping.cansignalname»
«var CANSignalDescription canSignal=canSignals.get(signalName)»
«var String[] splittedMN=mapping.mappingName.toString.toLowerCase.split("\\.")»
«IF(splittedMN.get(splittedMN.size-1).compareTo(signalName.split("\\.").get(0).toLowerCase)==0)»
«{
	var boolean test=true;
	for(id:canIDs)
		if(id.compareTo(canSignal.m_CANID)==0)
			test=false;
	if(test)
		canIDs.add(canSignal.m_CANID);
	""
}»
CANID       : «canSignal.m_CANID»
FQDN        : «canSignal.m_FQDN»
startBit    : «canSignal.m_startBit»
length      : «canSignal.m_length»
lengthBytes : «canSignal.m_lengthBytes»
endian      : «canSignal.m_endian»
multiplyBy  : «canSignal.m_multiplyBy»
add         : «canSignal.m_add»
rangeStart  : «canSignal.m_rangeStart»
rangeEnd    : «canSignal.m_rangeEnd»

«ENDIF»
«ENDFOR»*/

#ifndef CANMAPPINGTESTSUITE_H_
#define CANMAPPINGTESTSUITE_H_

#include "GeneratedHeaders_«generatedHeadersFile».h"
#include "GeneratedHeaders_AutomotiveData.h"
#include "cxxtest/TestSuite.h"
#include <sstream>

using namespace std;

/**
 * The actual testsuite starts here.
 */
class CANBridgeTest : public CxxTest::TestSuite {
    public:
        void testSample() {
        	
        	«var String init=""»
        	«var int fieldsNum=mapping.mappings.size»
        	«IF fieldsNum>0»
			«var Iterator<Mapping> iter = mapping.mappings.iterator»
			«{
        	//(1,1234.56,3.1415,0.00000001)
    			var Random r = new Random();
    			var double rangeMin=-10000.0;
    			var double rangeMax=10000.0;
				while (iter.hasNext()){
				iter.next();
				var double randomValue = rangeMin + (rangeMax - rangeMin) * r.nextDouble();
				init+=randomValue+"";
				if(iter.hasNext())init+=", ";
        	}}»
        	«ENDIF»
        	
            «var String HLName= (Character.toLowerCase(mapping.mappingName.toString.charAt(0)) + mapping.mappingName.toString.substring(1)).replaceAll("\\.", "_")»
        	canmapping::«mapping.mappingName.toString.replaceAll("\\.", "::")» «HLName»_1«IF fieldsNum>0»«"("+init+")"»«ENDIF»;
        	canmapping::«mapping.mappingName.toString.replaceAll("\\.", "::")» «HLName»_2;
        	
        	stringstream ss1,ss2;
        	ss1 << «HLName»_1;
        	
            TS_ASSERT(ss1.str().compare(ss2.str())!=0);
            
            ss1 >> «HLName»_2;
            ss2 << «HLName»_2;
            
        	//cout << endl;
        	//cout << ss1.str() << endl;
        	//cout << ss2.str() << endl;
            //cout << endl;
        	//cout<<«HLName»_1.toString();
        	//cout<<«HLName»_2.toString();
        	
            TS_ASSERT(ss1.str().compare(ss2.str())==0);
«var int testIndex=0»
«FOR test : canSignalTesting»
«IF test.mappingName.toString.compareTo(mapping.mappingName.toString)==0»
«var String testName="test_"+(testIndex++)»
    		«var HashMap<String,String> GCMs=new HashMap<String,String>»
			// Mapping name «test.mappingName»
			«var int gcmIndex=0»
			«FOR description : test.CANMessageDescriptions»
			// id «description.canIdentifier»
			// payload «description.payload» : length «(description.payload.length-2)/2»
			«IF description.payload.length==18»
			«var String gcmName="gcm_"+(gcmIndex++)»
			::automotive::GenericCANMessage «gcmName»;
			«gcmName».setIdentifier(«description.canIdentifier»);
			«gcmName».setLength(«(description.payload.length-2)/2»);
			«gcmName».setData(«description.payload»);
			«GCMs.put(description.canIdentifier,gcmName)»
			«ENDIF»
    		«ENDFOR»
    		
    		canmapping::«mapping.mappingName.toString.replaceAll("\\.", "::")» «testName»;
    		«IF canIDs.length==GCMs.size»
			«FOR canid:canIDs»
			«testName».decode(«GCMs.get(canid)»);
			«ENDFOR»
			
        	«var ArrayList<String> asserts=new ArrayList<String>»
        	«var ArrayList<String> gets=new ArrayList<String>»
			«{
			for(var int index=0;index<mapping.mappings.size;index++){
				var String capitalizedName=""
				var String[] chunks=mapping.mappings.get(index).cansignalname.split('\\.')
				for(chunk:chunks) capitalizedName+=chunk.toFirstUpper
				for(result:test.results)
					if(result.signalIdentifier.compareTo(mapping.mappings.get(index).signalIdentifier)==0)
						asserts+="TS_ASSERT_DELTA("+testName+".get"+capitalizedName+"() , "+result.expectedResult+", 1e-5);"+'\n'
			}
			}»
			«FOR assertions:asserts»
			«assertions»
			«ENDFOR»
			
			«IF !(mapping.unordered!=null && mapping.unordered.compareTo("unordered")==0)»
			
			«{testName="test_"+(testIndex++);""}»
			canmapping::«mapping.mappingName.toString.replaceAll("\\.", "::")» «testName»;
			«var ArrayList<String> decodes=new ArrayList<String>»
        	«var ArrayList<String> orderAsserts=new ArrayList<String>»
			«{
				for(var int i=canIDs.length-1;i>=0;i--)
					decodes+=testName+".decode("+GCMs.get(canIDs.get(i))+");"
				for(var int index=0;index<mapping.mappings.size;index++){
				var String capitalizedName=""
				var String[] chunks=mapping.mappings.get(index).cansignalname.split('\\.')
				for(chunk:chunks) capitalizedName+=chunk.toFirstUpper
				for(result:test.results)
					if(result.signalIdentifier.compareTo(mapping.mappings.get(index).signalIdentifier)==0)
						orderAsserts+="TS_ASSERT_DELTA("+testName+".get"+capitalizedName+"() , 0.0, 1e-5);"+'\n'
			}
			}»
			«FOR decode:decodes»
			«decode»
			«ENDFOR»
			«FOR assertions:orderAsserts»
			«assertions»
			«ENDFOR»
			«ENDIF»

    		«ELSE»
    		// not enough CAN messages were provided
    		«ENDIF»
            	«ENDIF»
            «ENDFOR»
        }
};

#endif /*CANMAPPINGTESTSUITE_H_*/
'''

/* This method generates the UPPAAL file content when the order of expected messages does not matter. */
	def generateUPPAALUnordered(CANSignalMapping mapping,HashMap<String, CANSignalDescription> canSignals) '''
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE nta PUBLIC '-//Uppaal Team//DTD Flat System 1.1//EN' 'http://www.it.uu.se/research/group/darts/uppaal/flat-1_2.dtd'>
<nta>
	<declaration>// Place global declarations here.
/*This software is open source. Please see COPYING and AUTHORS for further information.
This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
UPPAAL file for: «mapping.mappingName.toString»
Unordered messages*/
«var ArrayList<String> canIDs=new ArrayList<String>»/*
«FOR currenMapping : mapping.mappings»
«var String signalName=currenMapping.cansignalname»
«var CANSignalDescription canSignal=canSignals.get(signalName)»
«var String[] splittedMN=mapping.mappingName.toString.toLowerCase.split("\\.")»
«IF(splittedMN.get(splittedMN.size-1).compareTo(signalName.split("\\.").get(0).toLowerCase)==0)»
«{
	var boolean test=true;
	for(id:canIDs)
		if(id.compareTo(canSignal.m_CANID)==0)
			test=false;
	if(test)
		canIDs.add(canSignal.m_CANID);
	""
}»
CANID       : «canSignal.m_CANID»
«ENDIF»
«ENDFOR»*/
int ID=0;
const int N=«canIDs.size»;
const int MAX=N*5;
«var String expectedM=""»
«var String receivedM=""»
«var String notWantedM»
«{
	var int index=0;
	var String tempString;
	for(currentM:canIDs)
	{
		tempString=canIDs.get(index);
		tempString=tempString.substring(2,tempString.length());
		notWantedM=(Long.parseLong(tempString,16)+1)+"";
		tempString=Long.parseLong(tempString,16)+"";
		if(index<canIDs.size-1)
		{
			expectedM+=tempString+",";
			receivedM+="false,";
		}
		else
		{
			expectedM+=tempString;
			receivedM+="false";
		}
		index++;
	}
}»
int list[N+1]={«expectedM»,«notWantedM»};
int expectedID[N]={«expectedM»};

int[0,MAX] counter=0;
bool received[N]={«receivedM»};

urgent chan message,Go;
</declaration>
	<template>
		<name x="5" y="5">messageGenerator</name>
		<declaration>// Place local declarations here.

void nextID(int[0,N] canid)
{
    int[0,N] index=0;
    ID=list[canid];
    counter++;    
    if(counter==MAX)
    {
        for(index=0;index&lt;N;index++)
        {
            if(!received[index])
            {
                ID=expectedID[index];
                counter=0;
                return;
            }
        }
        counter=0;
    }
}</declaration>
		<location id="id0" x="17" y="-102">
			<name x="0" y="-136">Send</name>
			<committed/>
		</location>
		<location id="id1" x="-187" y="-102">
			<name x="-212" y="-144">Ready</name>
		</location>
		<init ref="id1"/>
		<transition>
			<source ref="id0"/>
			<target ref="id1"/>
			<label kind="synchronisation" x="-110" y="-68">message!</label>
			<nail x="17" y="-42"/>
			<nail x="-187" y="-42"/>
		</transition>
		<transition>
			<source ref="id1"/>
			<target ref="id0"/>
			<label kind="select" x="-119" y="-136">n:int[0,N]</label>
			<label kind="synchronisation" x="-93" y="-119">Go!</label>
			<label kind="assignment" x="-127" y="-102">nextID(n)</label>
		</transition>
	</template>
	<template>
		<name>Receiver</name>
		<declaration>bool complete=false;

void reset()
{
    int[0,N] index=0;
    for(index=0;index&lt;N;index++)
    {
        received[index]=false;
    }
    complete=false;
}

void nextExpected()
{
    int[0,N] index=0;
    if(complete)
    {
        reset();
    }

    for(index=0;index&lt;N;index++)
    {
        if(ID==expectedID[index])
        {
            received[index]=true;
        }
    }
    complete=true;
    for(index=0;index&lt;N;index++)
    {
        if(!received[index])
        {
            complete=false;
            return;
        }
    }
}</declaration>
		<location id="id2" x="-25" y="-17">
			<name x="-59" y="-51">Operating</name>
		</location>
		<init ref="id2"/>
		<transition>
			<source ref="id2"/>
			<target ref="id2"/>
			<label kind="synchronisation" x="119" y="-25">message?</label>
			<label kind="assignment" x="102" y="-8">nextExpected()</label>
			<nail x="85" y="25"/>
			<nail x="85" y="-51"/>
		</transition>
	</template>
	<template>
		<name>Synchronizer</name>
		<location id="id3" x="-34" y="0">
			<name x="-51" y="-34">Normal</name>
		</location>
		<init ref="id3"/>
		<transition>
			<source ref="id3"/>
			<target ref="id3"/>
			<label kind="synchronisation" x="-42" y="34">Go?</label>
			<nail x="-76" y="51"/>
			<nail x="17" y="51"/>
		</transition>
	</template>
	<system>// Place template instantiations here.

system messageGenerator,Receiver,Synchronizer;
    </system>
	<queries>
		<query>
			<formula>!Receiver.complete--&gt;Receiver.complete
			</formula>
			<comment>
			</comment>
		</query>
		<query>
			<formula>A[] not deadlock
			</formula>
			<comment>
			</comment>
		</query>
	</queries>
</nta>
'''	

/* This method generates the UPPAAL file content when the order of expected messages matters. */
	def generateUPPAALOrdered(CANSignalMapping mapping,HashMap<String, CANSignalDescription> canSignals) '''
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE nta PUBLIC '-//Uppaal Team//DTD Flat System 1.1//EN' 'http://www.it.uu.se/research/group/darts/uppaal/flat-1_2.dtd'>
<nta>
	<declaration>// Place global declarations here.
/*This software is open source. Please see COPYING and AUTHORS for further information.
This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
UPPAAL file for: «mapping.mappingName.toString»
Ordered messages*/
«var ArrayList<String> canIDs=new ArrayList<String>»/*
«FOR currenMapping : mapping.mappings»
«var String signalName=currenMapping.cansignalname»
«var CANSignalDescription canSignal=canSignals.get(signalName)»
«var String[] splittedMN=mapping.mappingName.toString.toLowerCase.split("\\.")»
«IF(splittedMN.get(splittedMN.size-1).compareTo(signalName.split("\\.").get(0).toLowerCase)==0)»
«{
	var boolean test=true;
	for(id:canIDs)
		if(id.compareTo(canSignal.m_CANID)==0)
			test=false;
	if(test)
		canIDs.add(canSignal.m_CANID);
	""
}»
CANID       : «canSignal.m_CANID»
«ENDIF»
«ENDFOR»*/
int ID=0;
const int N=«canIDs.size»;
const int MAX=N*5;
«var String expectedM=""»
«var String receivedM=""»
«var String notWantedM»
«var int[] IDs=newIntArrayOfSize(canIDs.size)»
«var int index=0»
«{
	
	var String tempString;
	for(currentM:canIDs)
	{
		tempString=canIDs.get(index);
		tempString=tempString.substring(2,tempString.length());
		IDs.set(index,Integer.parseInt(tempString,16));
		notWantedM=(Integer.parseInt(tempString,16)+1)+"";
		tempString=Integer.parseInt(tempString,16)+"";
		if(index<canIDs.size-1)
		{
			expectedM+=tempString+",";
			receivedM+="false,";
		}
		else
		{
			expectedM+=tempString;
			receivedM+="false";
		}
		index++;
	}
}»
int list[N+1]={«expectedM»,«notWantedM»};
int expectedID[N]={«expectedM»};
bool received[N]={«receivedM»};
bool allReceived=false;

urgent chan message,Go;
</declaration>
	<template>
		<name x="5" y="5">messageGenerator</name>
		<declaration>// Place local declarations here.

void updateReceiveList(int[0,N-1] current)
{
    int[0,N] index=0;
    received[current]=true;
    for(index=current+1;index&lt;N;index++)
    {
        received[index]=false;
    }
}


void updateLocalBuffer()
{
    int[0,N] index=0;
    int[0,N] index2=0;
    for(index=0;index&lt;N;index++)
    {
        if(ID==expectedID[index])
        {
            if(index==0)
            {
                updateReceiveList(index);
                return;
            }
            else
            {
                for(index2=0;index2&lt;index;index2++)
                {
                    if(!received[index2])
                    {
                        return;
                    }
                }
                updateReceiveList(index);
                if(index==N-1)
                {
                    allReceived=true;
                }
            }
        }
    }
}
                    
</declaration>
		<location id="id0" x="17" y="-102">
			<name x="0" y="-136">Send</name>
			<committed/>
		</location>
		<location id="id1" x="-187" y="-102">
			<name x="-212" y="-144">Ready</name>
		</location>
		<init ref="id1"/>
		<transition>
			<source ref="id0"/>
			<target ref="id1"/>
			<label kind="synchronisation" x="-110" y="-68">message!</label>
			<label kind="assignment" x="-161" y="-42">updateLocalBuffer()</label>
			<nail x="17" y="-42"/>
			<nail x="-187" y="-42"/>
		</transition>
		<transition>
			<source ref="id1"/>
			<target ref="id0"/>
			<label kind="select" x="-119" y="-136">canid:int[0,N]</label>
			<label kind="synchronisation" x="-93" y="-119">Go!</label>
			<label kind="assignment" x="-119" y="-102">ID=list[canid]</label>
		</transition>
	</template>
	<template>
		<name>Receiver</name>
		<declaration>void reset()
{
    int[0,N] index=0;
    for(index=0;index&lt;N;index++)
    {
        received[index]=false;
    }
    allReceived=false;
}</declaration>
«var int[] stateXPosition=newIntArrayOfSize(canIDs.size)»
«{
	var int initialX=-250;
	for(index=0;index<canIDs.size;index++)
	{
		stateXPosition.set(index,initialX);
		initialX+=160;
	}
}»	
«var int stateYPosition=-17»
«var int[] stateNameXPosition=newIntArrayOfSize(canIDs.size)»
«{
	var int initialX=-267;
	for(index=0;index<canIDs.size;index++)
	{
		stateNameXPosition.set(index,initialX);
		initialX+=160;
	}
}»	
«var int stateNameYPosition=-52»
«FOR a:canIDs»
	«var int myIndex=canIDs.indexOf(a)»
	<location id="id«myIndex+2»" x="«stateXPosition.get(myIndex)»" y="«stateYPosition»">
		<name x="«stateNameXPosition.get(myIndex)»" y="«stateNameYPosition»">State«myIndex»</name>
	</location>
«ENDFOR»
	<init ref="id2" />
	
«FOR a:canIDs»
	«var int myIndex=canIDs.indexOf(a)»
	<transition>
		<source ref="id«myIndex+2»"/>
		<target ref="id«myIndex+2»"/>
		<label kind="guard" x="«stateXPosition.get(myIndex)-30»" y="«stateYPosition+30»">ID!=«IDs.get(myIndex)»</label>
		<label kind="synchronisation" x="«stateXPosition.get(myIndex)-30»" y="«stateYPosition+50»">message?</label>
		<nail x="«stateXPosition.get(myIndex)-50»" y="«stateYPosition+50»"/>
		<nail x="«stateXPosition.get(myIndex)+50»" y="«stateYPosition+50»"/>
	</transition>
	«IF myIndex<canIDs.size-1»
		<transition>
			<source ref="id«myIndex+2»"/>
			<target ref="id«myIndex+3»"/>
			<label kind="guard" x="«stateXPosition.get(myIndex)+30»" y="«stateYPosition-15»">ID==«IDs.get(myIndex)»</label>
			<label kind="synchronisation" x="«stateXPosition.get(myIndex)+30»" y="«stateYPosition»">message?</label>
		</transition>
	«ELSE»
		<transition>
			<source ref="id«myIndex+2»"/>
			<target ref="id2"/>
			<label kind="guard" x="«stateXPosition.get(0)+15»" y="«stateYPosition+70»">ID==«IDs.get(myIndex)»</label>
			<label kind="synchronisation" x="«stateXPosition.get(0)+15»" y="«stateYPosition+85»">message?</label>
			<label kind="assignment" x="«stateXPosition.get(0)+15»" y="«stateYPosition+98»">reset()</label>
			<nail x="«stateXPosition.get(myIndex)»" y="«stateYPosition+100»"/>
			<nail x="«stateXPosition.get(0)»" y="«stateYPosition+100»"/>
		</transition>
	«ENDIF»
«ENDFOR»

«var int diff=20»
«IF canIDs.size>2»
	«FOR a:canIDs»
		«var int myIndex=canIDs.indexOf(a)»
		«IF myIndex>0 && myIndex<canIDs.size-1»
			«FOR i:(myIndex+1)..(canIDs.size-1)»
				<transition>
					<source ref="id«i+2»"/>
					<target ref="id«myIndex+2»"/>
					<label kind="guard" x="«stateXPosition.get(myIndex)+(stateXPosition.get(i)-stateXPosition.get(myIndex))/2»" y="«stateYPosition-70-diff*(i-myIndex)»">ID==«IDs.get(myIndex-1)»</label>
					<label kind="synchronisation" x="«stateXPosition.get(myIndex)+(stateXPosition.get(i)-stateXPosition.get(myIndex))/2»" y="«stateYPosition-50-diff*(i-myIndex)»">message?</label>
					<nail x="«stateXPosition.get(i)-10»" y="«stateYPosition-50-diff*(i-myIndex)»"/>
					<nail x="«stateXPosition.get(myIndex)+10»" y="«stateYPosition-50-diff*(i-myIndex)»"/>
				</transition>
			«ENDFOR»
		«ENDIF»
	«ENDFOR»
«ENDIF»
</template>
	<template>
		<name>Synchronizer</name>
		<location id="id«canIDs.size+2»" x="-34" y="0">
			<name x="-51" y="-34">Normal</name>
		</location>
		<init ref="id«canIDs.size+2»"/>
		<transition>
			<source ref="id«canIDs.size+2»"/>
			<target ref="id«canIDs.size+2»"/>
			<label kind="synchronisation" x="-42" y="34">Go?</label>
			<nail x="-76" y="51"/>
			<nail x="17" y="51"/>
		</transition>
	</template>
	<system>// Place template instantiations here.

system messageGenerator,Receiver,Synchronizer;
    </system>
	<queries>
		<query>
			<formula>!Receiver.State0 &amp;&amp; !allReceived--&gt;Receiver.State0
			</formula>
			<comment>
			</comment>
		</query>
		<query>
			<formula>!Receiver.State0 &amp;&amp; allReceived--&gt;Receiver.State0
			</formula>
			<comment>
			</comment>
		</query>
		<query>
			<formula>A[] not deadlock
			</formula>
			<comment>
			</comment>
		</query>
	</queries>
</nta>
'''	

    /* This method generates the UPPAAL file content. */
	def generateUPPAALFileContent(CANSignalMapping mapping,HashMap<String, CANSignalDescription> canSignals) '''
«IF mapping.unordered!=null && mapping.unordered.compareTo("unordered")==0»
«generateUPPAALUnordered(mapping,canSignals)»
«ELSE»
	«var ArrayList<String> canIDs=new ArrayList<String>»
	«FOR currenMapping : mapping.mappings»
		«var String signalName=currenMapping.cansignalname»
		«var CANSignalDescription canSignal=canSignals.get(signalName)»
		«var String[] splittedMN=mapping.mappingName.toString.toLowerCase.split("\\.")»
		«IF(splittedMN.get(splittedMN.size-1).compareTo(signalName.split("\\.").get(0).toLowerCase)==0)»
		«{
			var boolean test=true;
			for(id:canIDs)
				if(id.compareTo(canSignal.m_CANID)==0)
					test=false;
			if(test)
				canIDs.add(canSignal.m_CANID);
			""
		}»
		«ENDIF»
	«ENDFOR»
	«IF canIDs.size>1»
		«generateUPPAALOrdered(mapping,canSignals)»
	«ELSE»
	«ENDIF»
«ENDIF»
'''	
}
