/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */

#ifndef SUB_STRUCTURE_TEST17CHILD_H
#define SUB_STRUCTURE_TEST17CHILD_H

// core/platform.h must be included to setup platform-dependent header files and configurations.
#include "core/platform.h"


#include "core/base/Visitable.h"
#include "core/data/SerializableData.h"


#include "GeneratedHeaders_Test17.h"
namespace sub {
	namespace structure {
		using namespace std;
		
		class Test17Child : public sub::structure::Test17Super {
			public:
				Test17Child();
		
				Test17Child(
				const std::string &val0
				);
		
				virtual ~Test17Child();
		
				/**
				 * Copy constructor.
				 *
				 * @param obj Reference to an object of this class.
				 */
				Test17Child(const Test17Child &obj);
		
				/**
				 * Assignment operator.
				 *
				 * @param obj Reference to an object of this class.
				 * @return Reference to this instance.
				 */
				Test17Child& operator=(const Test17Child &obj);
		
			public:
				/**
				 * @return myName.
				 */
				std::string getMyName() const;
				
				/**
				 * This method sets myName.
				 *
				 * @param val Value for myName.
				 */
				void setMyName(const std::string &val);
		
			public:
				/**
				 * This method returns the message id.
				 *
				 * @return Message id.
				 */
				static int32_t ID();
		
				/**
				 * This method returns the short message name.
				 *
				 * @return Short message name.
				 */
				static const string ShortName();
		
				/**
				 * This method returns the long message name include package/sub structure.
				 *
				 * @return Long message name.
				 */
				static const string LongName();
		
			public:
				virtual void accept(core::base::Visitor &v);
		
				virtual ostream& operator<<(ostream &out) const;
				virtual istream& operator>>(istream &in);
		
				virtual const string toString() const;
		
			private:
				std::string m_myName;
		
		};
	} // structure
} // sub

#endif /*SUB_STRUCTURE_TEST17CHILD_H*/
