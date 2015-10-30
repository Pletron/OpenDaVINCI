/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */


#include "core/base/Hash.h"
#include "core/base/Deserializer.h"
#include "core/base/SerializationFactory.h"
#include "core/base/Serializer.h"


#include "generated/subpackage/Test9C.h"

namespace subpackage {
		using namespace std;
		using namespace core::base;
	
	
		Test9C::Test9C() :
		    SerializableData(), Visitable()
			, m_attribute1("")
		{
		}
	
		Test9C::Test9C(
			const std::string &val0
		) :
		    SerializableData(), Visitable()
			, m_attribute1(val0)
		{
		}
	
		Test9C::Test9C(const Test9C &obj) :
		    SerializableData(), Visitable()
			, m_attribute1(obj.m_attribute1)
		{
		}
		
		Test9C::~Test9C() {
		}
	
		Test9C& Test9C::operator=(const Test9C &obj) {
			m_attribute1 = obj.m_attribute1;
			return (*this);
		}
	
		int32_t Test9C::ID() {
			return 11;
		}
	
		const string Test9C::ShortName() {
			return "Test9C";
		}
	
		const string Test9C::LongName() {
			return "subpackage.Test9C";
		}
	
		std::string Test9C::getAttribute1() const {
			return m_attribute1;
		}
		
		void Test9C::setAttribute1(const std::string &val) {
			m_attribute1 = val;
		}
	
		void Test9C::accept(core::base::Visitor &v) {
			v.visit(CRC32 < CharList<'a', CharList<'t', CharList<'t', CharList<'r', CharList<'i', CharList<'b', CharList<'u', CharList<'t', CharList<'e', CharList<'1', NullType> > > > > > > > > >  >::RESULT, 0, "Test9C.attribute1", "attribute1", m_attribute1);
		}
	
		const string Test9C::toString() const {
			stringstream s;
	
	
			s << "Attribute1: " << getAttribute1() << " ";
	
			return s.str();
		}
	
		ostream& Test9C::operator<<(ostream &out) const {
	
			SerializationFactory& sf = SerializationFactory::getInstance();
	
			core::SharedPointer<Serializer> s = sf.getSerializer(out);
	
			s->write(CRC32 < CharList<'a', CharList<'t', CharList<'t', CharList<'r', CharList<'i', CharList<'b', CharList<'u', CharList<'t', CharList<'e', CharList<'1', NullType> > > > > > > > > >  >::RESULT,
					m_attribute1);
			return out;
		}
	
		istream& Test9C::operator>>(istream &in) {
	
			SerializationFactory& sf = SerializationFactory::getInstance();
	
			core::SharedPointer<Deserializer> d = sf.getDeserializer(in);
	
			d->read(CRC32 < CharList<'a', CharList<'t', CharList<'t', CharList<'r', CharList<'i', CharList<'b', CharList<'u', CharList<'t', CharList<'e', CharList<'1', NullType> > > > > > > > > >  >::RESULT,
					m_attribute1);
			return in;
		}
} // subpackage
