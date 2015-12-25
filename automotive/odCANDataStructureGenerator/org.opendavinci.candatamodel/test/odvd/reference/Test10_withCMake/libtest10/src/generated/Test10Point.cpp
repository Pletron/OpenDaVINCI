/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */


#include "core/base/Hash.h"
#include "core/base/Deserializer.h"
#include "core/base/SerializationFactory.h"
#include "core/base/Serializer.h"


#include "generated/Test10Point.h"

	using namespace std;
	using namespace core::base;


	Test10Point::Test10Point() :
	    SerializableData(), Visitable()
		, m_x(0)
		, m_y(0)
	{
	}

	Test10Point::Test10Point(
		const float &val0, 
		const float &val1
	) :
	    SerializableData(), Visitable()
		, m_x(val0)
		, m_y(val1)
	{
	}

	Test10Point::Test10Point(const Test10Point &obj) :
	    SerializableData(), Visitable()
		, m_x(obj.m_x)
		, m_y(obj.m_y)
	{
	}
	
	Test10Point::~Test10Point() {
	}

	Test10Point& Test10Point::operator=(const Test10Point &obj) {
		m_x = obj.m_x;
		m_y = obj.m_y;
		return (*this);
	}

	int32_t Test10Point::ID() {
		return 10;
	}

	const string Test10Point::ShortName() {
		return "Test10Point";
	}

	const string Test10Point::LongName() {
		return "Test10Point";
	}

	float Test10Point::getX() const {
		return m_x;
	}
	
	void Test10Point::setX(const float &val) {
		m_x = val;
	}
	float Test10Point::getY() const {
		return m_y;
	}
	
	void Test10Point::setY(const float &val) {
		m_y = val;
	}

	void Test10Point::accept(core::base::Visitor &v) {
		v.visit(CRC32 < CharList<'x', NullType>  >::RESULT, 0, "Test10Point.x", "x", m_x);
		v.visit(CRC32 < CharList<'y', NullType>  >::RESULT, 0, "Test10Point.y", "y", m_y);
	}

	const string Test10Point::toString() const {
		stringstream s;


		s << "X: " << getX() << " ";
		s << "Y: " << getY() << " ";

		return s.str();
	}

	ostream& Test10Point::operator<<(ostream &out) const {

		SerializationFactory& sf = SerializationFactory::getInstance();

		core::SharedPointer<Serializer> s = sf.getSerializer(out);

		s->write(CRC32 < CharList<'x', NullType>  >::RESULT,
				m_x);
		s->write(CRC32 < CharList<'y', NullType>  >::RESULT,
				m_y);
		return out;
	}

	istream& Test10Point::operator>>(istream &in) {

		SerializationFactory& sf = SerializationFactory::getInstance();

		core::SharedPointer<Deserializer> d = sf.getDeserializer(in);

		d->read(CRC32 < CharList<'x', NullType>  >::RESULT,
				m_x);
		d->read(CRC32 < CharList<'y', NullType>  >::RESULT,
				m_y);
		return in;
	}
