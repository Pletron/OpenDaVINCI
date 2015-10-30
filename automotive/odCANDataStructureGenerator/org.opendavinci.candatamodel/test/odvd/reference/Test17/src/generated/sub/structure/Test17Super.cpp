/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */


#include "core/base/Hash.h"
#include "core/base/Deserializer.h"
#include "core/base/SerializationFactory.h"
#include "core/base/Serializer.h"


#include "generated/sub/structure/Test17Super.h"

namespace sub {
	namespace structure {
			using namespace std;
			using namespace core::base;
		
		
			Test17Super::Test17Super() :
			    SerializableData(), Visitable()
				, m_myData(4.6) // TODO: Validation if the default value is of the desired type.
				, m_myValue(1) // TODO: Validation if the default value is of the desired type.
			{
			}
		
			Test17Super::Test17Super(
				const double &val0, 
				const int32_t &val1
			) :
			    SerializableData(), Visitable()
				, m_myData(val0)
				, m_myValue(val1)
			{
			}
		
			Test17Super::Test17Super(const Test17Super &obj) :
			    SerializableData(), Visitable()
				, m_myData(obj.m_myData)
				, m_myValue(obj.m_myValue)
			{
			}
			
			Test17Super::~Test17Super() {
			}
		
			Test17Super& Test17Super::operator=(const Test17Super &obj) {
				m_myData = obj.m_myData;
				m_myValue = obj.m_myValue;
				return (*this);
			}
		
			int32_t Test17Super::ID() {
				return 17;
			}
		
			const string Test17Super::ShortName() {
				return "Test17Super";
			}
		
			const string Test17Super::LongName() {
				return "sub.structure.Test17Super";
			}
		
			double Test17Super::getMyData() const {
				return m_myData;
			}
			
			void Test17Super::setMyData(const double &val) {
				m_myData = val;
			}
			int32_t Test17Super::getMyValue() const {
				return m_myValue;
			}
			
			void Test17Super::setMyValue(const int32_t &val) {
				m_myValue = val;
			}
		
			void Test17Super::accept(core::base::Visitor &v) {
				v.visit(CRC32 < CharList<'m', CharList<'y', CharList<'D', CharList<'a', CharList<'t', CharList<'a', NullType> > > > > >  >::RESULT, 0, "Test17Super.myData", "myData", m_myData);
				v.visit(CRC32 < CharList<'m', CharList<'y', CharList<'V', CharList<'a', CharList<'l', CharList<'u', CharList<'e', NullType> > > > > > >  >::RESULT, 0, "Test17Super.myValue", "myValue", m_myValue);
			}
		
			const string Test17Super::toString() const {
				stringstream s;
		
		
				s << "MyData: " << getMyData() << " ";
				s << "MyValue: " << getMyValue() << " ";
		
				return s.str();
			}
		
			ostream& Test17Super::operator<<(ostream &out) const {
		
				SerializationFactory& sf = SerializationFactory::getInstance();
		
				core::SharedPointer<Serializer> s = sf.getSerializer(out);
		
				s->write(CRC32 < CharList<'m', CharList<'y', CharList<'D', CharList<'a', CharList<'t', CharList<'a', NullType> > > > > >  >::RESULT,
						m_myData);
				s->write(CRC32 < CharList<'m', CharList<'y', CharList<'V', CharList<'a', CharList<'l', CharList<'u', CharList<'e', NullType> > > > > > >  >::RESULT,
						m_myValue);
				return out;
			}
		
			istream& Test17Super::operator>>(istream &in) {
		
				SerializationFactory& sf = SerializationFactory::getInstance();
		
				core::SharedPointer<Deserializer> d = sf.getDeserializer(in);
		
				d->read(CRC32 < CharList<'m', CharList<'y', CharList<'D', CharList<'a', CharList<'t', CharList<'a', NullType> > > > > >  >::RESULT,
						m_myData);
				d->read(CRC32 < CharList<'m', CharList<'y', CharList<'V', CharList<'a', CharList<'l', CharList<'u', CharList<'e', NullType> > > > > > >  >::RESULT,
						m_myValue);
				return in;
			}
	} // structure
} // sub
