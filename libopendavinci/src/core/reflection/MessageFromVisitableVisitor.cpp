/**
 * OpenDaVINCI - Portable middleware for distributed components.
 * Copyright (C) 2015 Christian Berger
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

#include <cstdlib>
#include <cstring>

#include "core/SharedPointer.h"
#include "core/base/Serializable.h"
#include "core/base/Visitable.h"
#include "core/reflection/Field.h"
#include "core/reflection/MessageFromVisitableVisitor.h"
#include "generated/coredata/reflection/AbstractField.h"

namespace core {
    namespace reflection {

        using namespace core;
        using namespace core::base;
        using namespace coredata::reflection;

        MessageFromVisitableVisitor::MessageFromVisitableVisitor() :
            m_message() {}

        MessageFromVisitableVisitor::~MessageFromVisitableVisitor() {}

        Message MessageFromVisitableVisitor::getMessage() {
            return m_message;
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, Serializable &v) {
            try {
                // A Serializable is replaced by a generic message representation. Thus,
                // try to cast v into a Visitable and visit it using a fresh Message.
                Visitable &visitable = dynamic_cast<Visitable&>(v);
                MessageFromVisitableVisitor msgFromVisitableVisitor;
                visitable.accept(msgFromVisitableVisitor);

                // Store the generic message representation.
                Field<Message> *f = new Field<Message>(msgFromVisitableVisitor.getMessage());
                f->setLongIdentifier(longId);
                f->setShortIdentifier(shortId);
                f->setLongName(longName);
                f->setShortName(shortName);
                f->setFieldDataType(coredata::reflection::AbstractField::SERIALIZABLE_T);
                m_message.addField(SharedPointer<AbstractField>(f));
            }
            catch (...) {
                // Cast was unsuccessful.
            }
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, bool &v) {
            Field<bool> *f = new Field<bool>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::BOOL_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, char &v) {
            Field<char> *f = new Field<char>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::CHAR_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, unsigned char &v) {
            Field<unsigned char> *f = new Field<unsigned char>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::UCHAR_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, int8_t &v) {
            Field<int8_t> *f = new Field<int8_t>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::INT8_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, int16_t &v) {
            Field<int16_t> *f = new Field<int16_t>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::INT16_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, uint16_t &v) {
            Field<uint16_t> *f = new Field<uint16_t>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::UINT16_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, int32_t &v) {
            Field<int32_t> *f = new Field<int32_t>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::INT32_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, uint32_t &v) {
            Field<uint32_t> *f = new Field<uint32_t>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::UINT32_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, int64_t &v) {
            Field<int64_t> *f = new Field<int64_t>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::INT64_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, uint64_t &v) {
            Field<uint64_t> *f = new Field<uint64_t>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::UINT64_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, float &v) {
            Field<float> *f = new Field<float>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::FLOAT_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, double &v) {
            Field<double> *f = new Field<double>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::DOUBLE_T);
            f->setSize(sizeof(v));
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, string &v) {
            Field<string> *f = new Field<string>(v);
            f->setLongIdentifier(longId);
            f->setShortIdentifier(shortId);
            f->setLongName(longName);
            f->setShortName(shortName);
            f->setFieldDataType(coredata::reflection::AbstractField::STRING_T);
            f->setSize(v.size());
            m_message.addField(SharedPointer<AbstractField>(f));
        }

        void MessageFromVisitableVisitor::visit(const uint32_t &longId, const uint8_t &shortId, const string &longName, const string &shortName, void *data, const uint32_t &size) {
            if (data != NULL) {
                // Copy the data.
                char* ptr = static_cast<char*>(malloc(size));
                memcpy(ptr, data, size);

                // Create a field.
                Field<SharedPointer<char> > *f = new Field<SharedPointer<char> >(SharedPointer<char>(ptr));
                f->setLongIdentifier(longId);
                f->setShortIdentifier(shortId);
                f->setLongName(longName);
                f->setShortName(shortName);
                f->setFieldDataType(coredata::reflection::AbstractField::DATA_T);
                f->setSize(size);
                m_message.addField(SharedPointer<AbstractField>(f));
            }
        }

    }
} // core::reflection

