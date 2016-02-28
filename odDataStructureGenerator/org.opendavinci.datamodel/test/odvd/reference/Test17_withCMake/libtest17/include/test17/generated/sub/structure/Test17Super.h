/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */

#ifndef SUB_STRUCTURE_TEST17SUPER_H
#define SUB_STRUCTURE_TEST17SUPER_H

#include "opendavinci/odcore/opendavinci.h"


#include "opendavinci/odcore/base/Visitable.h"
#include "opendavinci/odcore/data/SerializableData.h"


namespace sub {
	namespace structure {
		using namespace std;
		
		class Test17Super : public odcore::data::SerializableData, public odcore::base::Visitable {
			public:
				Test17Super();
		
				Test17Super(
				const double &val0, 
				const int32_t &val1
				);
		
				virtual ~Test17Super();
		
				/**
				 * Copy constructor.
				 *
				 * @param obj Reference to an object of this class.
				 */
				Test17Super(const Test17Super &obj);
		
				/**
				 * Assignment operator.
				 *
				 * @param obj Reference to an object of this class.
				 * @return Reference to this instance.
				 */
				Test17Super& operator=(const Test17Super &obj);
		
			public:
				/**
				 * @return myData.
				 */
				double getMyData() const;
				
				/**
				 * This method sets myData.
				 *
				 * @param val Value for myData.
				 */
				void setMyData(const double &val);
			public:
				/**
				 * @return myValue.
				 */
				int32_t getMyValue() const;
				
				/**
				 * This method sets myValue.
				 *
				 * @param val Value for myValue.
				 */
				void setMyValue(const int32_t &val);
		
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
		
				/**
				 * This method returns the message id.
				 *
				 * @return Message id.
				 */
				virtual int32_t getID() const;
		
				/**
				 * This method returns the short message name.
				 *
				 * @return Short message name.
				 */
				virtual const string getShortName() const;
		
				/**
				 * This method returns the long message name include package/sub structure.
				 *
				 * @return Long message name.
				 */
				virtual const string getLongName() const;
		
			public:
				virtual void accept(odcore::base::Visitor &v);
		
				virtual ostream& operator<<(ostream &out) const;
				virtual istream& operator>>(istream &in);
		
				virtual const string toString() const;
		
			private:
				double m_myData;
			private:
				int32_t m_myValue;
		
		};
	} // structure
} // sub

#endif /*SUB_STRUCTURE_TEST17SUPER_H*/
