/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */

#ifndef TEST12COMPLEX_H
#define TEST12COMPLEX_H

#include "opendavinci/odcore/opendavinci.h"


#include "opendavinci/odcore/base/Visitable.h"
#include "opendavinci/odcore/data/SerializableData.h"


using namespace std;

class Test12Complex : public odcore::data::SerializableData, public odcore::base::Visitable {
	public:
		Test12Complex();

		Test12Complex(
		const bool &val0, 
		const char &val1, 
		const int32_t &val2, 
		const uint32_t &val3, 
		const float &val4, 
		const double &val5, 
		const std::string &val6
		);

		virtual ~Test12Complex();

		/**
		 * Copy constructor.
		 *
		 * @param obj Reference to an object of this class.
		 */
		Test12Complex(const Test12Complex &obj);

		/**
		 * Assignment operator.
		 *
		 * @param obj Reference to an object of this class.
		 * @return Reference to this instance.
		 */
		Test12Complex& operator=(const Test12Complex &obj);

	public:
		/**
		 * @return attribute1.
		 */
		bool getAttribute1() const;
		
		/**
		 * This method sets attribute1.
		 *
		 * @param val Value for attribute1.
		 */
		void setAttribute1(const bool &val);
	public:
		/**
		 * @return attribute2.
		 */
		char getAttribute2() const;
		
		/**
		 * This method sets attribute2.
		 *
		 * @param val Value for attribute2.
		 */
		void setAttribute2(const char &val);
	public:
		/**
		 * @return attribute3.
		 */
		int32_t getAttribute3() const;
		
		/**
		 * This method sets attribute3.
		 *
		 * @param val Value for attribute3.
		 */
		void setAttribute3(const int32_t &val);
	public:
		/**
		 * @return attribute4.
		 */
		uint32_t getAttribute4() const;
		
		/**
		 * This method sets attribute4.
		 *
		 * @param val Value for attribute4.
		 */
		void setAttribute4(const uint32_t &val);
	public:
		/**
		 * @return attribute5.
		 */
		float getAttribute5() const;
		
		/**
		 * This method sets attribute5.
		 *
		 * @param val Value for attribute5.
		 */
		void setAttribute5(const float &val);
	public:
		/**
		 * @return attribute6.
		 */
		double getAttribute6() const;
		
		/**
		 * This method sets attribute6.
		 *
		 * @param val Value for attribute6.
		 */
		void setAttribute6(const double &val);
	public:
		/**
		 * @return attribute7.
		 */
		std::string getAttribute7() const;
		
		/**
		 * This method sets attribute7.
		 *
		 * @param val Value for attribute7.
		 */
		void setAttribute7(const std::string &val);

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
		bool m_attribute1;
	private:
		char m_attribute2;
	private:
		int32_t m_attribute3;
	private:
		uint32_t m_attribute4;
	private:
		float m_attribute5;
	private:
		double m_attribute6;
	private:
		std::string m_attribute7;

};

#endif /*TEST12COMPLEX_H*/
