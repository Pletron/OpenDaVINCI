/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */


#include "core/base/Hash.h"
#include "core/base/Deserializer.h"
#include "core/base/SerializationFactory.h"
#include "core/base/Serializer.h"


#include "generated/Test9B.h"

	using namespace std;
	using namespace core::base;


	Test9B::Test9B() :
	    SerializableData(), Visitable()
		, m_attribute1(true) // TODO: Validation if the default value is of the desired type.
	{
	}

	Test9B::Test9B(
		const bool &val0
	) :
	    SerializableData(), Visitable()
		, m_attribute1(val0)
	{
	}

	Test9B::Test9B(const Test9B &obj) :
	    SerializableData(), Visitable()
		, m_attribute1(obj.m_attribute1)
	{
	}
	
	Test9B::~Test9B() {
	}

	Test9B& Test9B::operator=(const Test9B &obj) {
		m_attribute1 = obj.m_attribute1;
		return (*this);
	}

	int32_t Test9B::ID() {
		return 10;
	}

	const string Test9B::ShortName() {
		return "Test9B";
	}

	const string Test9B::LongName() {
		return "Test9B";
	}

	bool Test9B::getAttribute1() const {
		return m_attribute1;
	}
	
	void Test9B::setAttribute1(const bool &val) {
		m_attribute1 = val;
	}

	void Test9B::accept(core::base::Visitor &v) {
		v.visit(CRC32 < CharList<'a', CharList<'t', CharList<'t', CharList<'r', CharList<'i', CharList<'b', CharList<'u', CharList<'t', CharList<'e', CharList<'1', NullType> > > > > > > > > >  >::RESULT, 0, "Test9B.attribute1", "attribute1", m_attribute1);
	}

	const string Test9B::toString() const {
		stringstream s;


		s << "Attribute1: " << getAttribute1() << " ";

		return s.str();
	}

	ostream& Test9B::operator<<(ostream &out) const {

		SerializationFactory& sf = SerializationFactory::getInstance();

		core::SharedPointer<Serializer> s = sf.getSerializer(out);

		s->write(CRC32 < CharList<'a', CharList<'t', CharList<'t', CharList<'r', CharList<'i', CharList<'b', CharList<'u', CharList<'t', CharList<'e', CharList<'1', NullType> > > > > > > > > >  >::RESULT,
				m_attribute1);
		return out;
	}

	istream& Test9B::operator>>(istream &in) {

		SerializationFactory& sf = SerializationFactory::getInstance();

		core::SharedPointer<Deserializer> d = sf.getDeserializer(in);

		d->read(CRC32 < CharList<'a', CharList<'t', CharList<'t', CharList<'r', CharList<'i', CharList<'b', CharList<'u', CharList<'t', CharList<'e', CharList<'1', NullType> > > > > > > > > >  >::RESULT,
				m_attribute1);
		return in;
	}
