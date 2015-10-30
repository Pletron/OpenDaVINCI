/*
 * This software is open source. Please see COPYING and AUTHORS for further information.
 *
 * This file is auto-generated. DO NOT CHANGE AS YOUR CHANGES MIGHT BE OVERWRITTEN!
 */


#include "core/base/Hash.h"
#include "core/base/Deserializer.h"
#include "core/base/SerializationFactory.h"
#include "core/base/Serializer.h"


#include "generated/Test13/subpackage/Test13Simple.h"

namespace test13 {
	namespace subpackage {
			using namespace std;
			using namespace core::base;
		
		
			Test13Simple::Test13Simple() :
			    SerializableData(), Visitable()
				, m_buttonState(UNDEFINED) // TODO: Validation if the default value is of the desired type.
			{
			}
		
			Test13Simple::Test13Simple(
				const Test13Simple::ButtonState &val0
			) :
			    SerializableData(), Visitable()
				, m_buttonState(val0)
			{
			}
		
			Test13Simple::Test13Simple(const Test13Simple &obj) :
			    SerializableData(), Visitable()
				, m_buttonState(obj.m_buttonState)
			{
			}
			
			Test13Simple::~Test13Simple() {
			}
		
			Test13Simple& Test13Simple::operator=(const Test13Simple &obj) {
				m_buttonState = obj.m_buttonState;
				return (*this);
			}
		
			int32_t Test13Simple::ID() {
				return 13;
			}
		
			const string Test13Simple::ShortName() {
				return "Test13Simple";
			}
		
			const string Test13Simple::LongName() {
				return "Test13.subpackage.Test13Simple";
			}
		
			Test13Simple::ButtonState Test13Simple::getButtonState() const {
				return m_buttonState;
			}
			
			void Test13Simple::setButtonState(const Test13Simple::ButtonState &val) {
				m_buttonState = val;
			}
		
			void Test13Simple::accept(core::base::Visitor &v) {
				int32_t int32t_buttonState = m_buttonState;
				v.visit(CRC32 < CharList<'b', CharList<'u', CharList<'t', CharList<'t', CharList<'o', CharList<'n', CharList<'S', CharList<'t', CharList<'a', CharList<'t', CharList<'e', NullType> > > > > > > > > > >  >::RESULT, 0, "Test13Simple.buttonState", "buttonState", int32t_buttonState);
			}
		
			const string Test13Simple::toString() const {
				stringstream s;
		
		
				switch(getButtonState()) {
					case PRESSED :
					s << "ButtonState: Test13Simple::PRESSED (1) ";
					break;
					case UNDEFINED :
					s << "ButtonState: Test13Simple::UNDEFINED (-1) ";
					break;
					case NOT_PRESSED :
					s << "ButtonState: Test13Simple::NOT_PRESSED (0) ";
					break;
				}
		
				return s.str();
			}
		
			ostream& Test13Simple::operator<<(ostream &out) const {
		
				SerializationFactory& sf = SerializationFactory::getInstance();
		
				core::SharedPointer<Serializer> s = sf.getSerializer(out);
		
				int32_t int32t_buttonState = m_buttonState;
				s->write(CRC32 < CharList<'b', CharList<'u', CharList<'t', CharList<'t', CharList<'o', CharList<'n', CharList<'S', CharList<'t', CharList<'a', CharList<'t', CharList<'e', NullType> > > > > > > > > > >  >::RESULT,
						int32t_buttonState);
				return out;
			}
		
			istream& Test13Simple::operator>>(istream &in) {
		
				SerializationFactory& sf = SerializationFactory::getInstance();
		
				core::SharedPointer<Deserializer> d = sf.getDeserializer(in);
		
				int32_t int32t_buttonState = 0;
				d->read(CRC32 < CharList<'b', CharList<'u', CharList<'t', CharList<'t', CharList<'o', CharList<'n', CharList<'S', CharList<'t', CharList<'a', CharList<'t', CharList<'e', NullType> > > > > > > > > > >  >::RESULT,
						int32t_buttonState);
				m_buttonState = static_cast<Test13Simple::ButtonState>(int32t_buttonState);
				return in;
			}
	} // subpackage
} // test13
