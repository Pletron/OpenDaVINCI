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

#include <cstring>
#include <sstream>

#include "core/base/Hash.h"
#include "core/base/Deserializer.h"
#include "core/base/SerializationFactory.h"
#include "core/base/Serializer.h"
#include "core/data/image/CompressedImage.h"

namespace core {
    namespace data {
        namespace image {

            using namespace std;
            using namespace core::base;

            CompressedImage::CompressedImage() :
                    SerializableData(),
                    m_name(""),
                    m_width(0),
                    m_height(0),
                    m_bytesPerPixel(0),
                    m_compressedSize(0),
                    m_imageData(NULL) {}

            CompressedImage::CompressedImage(const string &name, const uint32_t &width, const uint32_t &height, const uint32_t &bpp, const uint32_t &compressedSize) :
                    SerializableData(),
                    m_name(name),
                    m_width(width),
                    m_height(height),
                    m_bytesPerPixel(bpp),
                    m_compressedSize(compressedSize),
                    m_imageData(NULL) {
                m_imageData = new uint8_t[compressedSize];
            }

            CompressedImage::~CompressedImage() {
                OPENDAVINCI_CORE_DELETE_ARRAY(m_imageData);
            }

            CompressedImage::CompressedImage(const CompressedImage &obj) :
                    SerializableData(obj),
                    m_name(obj.getName()),
                    m_width(obj.getWidth()),
                    m_height(obj.getHeight()),
                    m_bytesPerPixel(obj.getBytesPerPixel()), 
                    m_compressedSize(obj.getCompressedSize()),
                    m_imageData(NULL) {
                OPENDAVINCI_CORE_DELETE_ARRAY(m_imageData);
                m_imageData = new uint8_t[m_compressedSize];
                ::memcpy(m_imageData, obj.getRawData(), obj.getCompressedSize());
            }

            CompressedImage& CompressedImage::operator=(const CompressedImage &obj) {
                SerializableData::operator=(obj);
                setName(obj.getName());
                setWidth(obj.getWidth());
                setHeight(obj.getHeight());
                setBytesPerPixel(obj.getBytesPerPixel());
                m_compressedSize = obj.getCompressedSize();

                OPENDAVINCI_CORE_DELETE_ARRAY(m_imageData);
                m_imageData = new uint8_t[m_compressedSize];
                ::memcpy(m_imageData, obj.getRawData(), obj.getCompressedSize());

                return (*this);
            }

            const string CompressedImage::getName() const {
                return m_name;
            }

            void CompressedImage::setName(const string &name) {
                m_name = name;
            }

            uint32_t CompressedImage::getWidth() const {
                return m_width;
            }

            void CompressedImage::setWidth(const uint32_t &width) {
                m_width = width;
            }

            uint32_t CompressedImage::getHeight() const {
                return m_height;
            }

            void CompressedImage::setHeight(const uint32_t &height) {
                m_height = height;
            }

            uint32_t CompressedImage::getBytesPerPixel() const {
                return m_bytesPerPixel;
            }

            void CompressedImage::setBytesPerPixel(const uint32_t &bytesPerPixel) {
                m_bytesPerPixel = bytesPerPixel;
            }

            uint32_t CompressedImage::getSize() const {
                return getWidth() * getHeight() * getBytesPerPixel();
            }

            uint32_t CompressedImage::getCompressedSize() const {
                return m_compressedSize;
            }

            uint8_t* CompressedImage::getRawData() const {
                return m_imageData;
            }

            ostream& CompressedImage::operator<<(ostream &out) const {
                SerializationFactory& sf=SerializationFactory::getInstance();;

                core::SharedPointer<Serializer> s = sf.getSerializer(out);

                s->write(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL4('n', 'a', 'm', 'e') >::RESULT,
                         1, "CompressedImage.name", "name",
                         getName());

                s->write(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL5('w', 'i', 'd', 't', 'h') >::RESULT,
                         2, "CompressedImage.width", "width",
                         getWidth());

                s->write(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL6('h', 'e', 'i', 'g', 'h', 't') >::RESULT,
                         3, "CompressedImage.height", "height",
                         getHeight());

                s->write(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL3('b', 'p', 'p') >::RESULT,
                         4, "CompressedImage.bytesPerPixel", "bytesPerPixel",
                         getBytesPerPixel());

                s->write(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL5('c', 's', 'i', 'z', 'e') >::RESULT,
                         5, "CompressedImage.compressedSize", "compressedSize",
                         getCompressedSize());

                s->write(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL4('d', 'a', 't', 'a') >::RESULT,
                         6, "CompressedImage.data", "data",
                         m_imageData, m_compressedSize);

                return out;
            }

            istream& CompressedImage::operator>>(istream &in) {
                SerializationFactory& sf=SerializationFactory::getInstance();;

                core::SharedPointer<Deserializer> d = sf.getDeserializer(in);

                d->read(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL4('n', 'a', 'm', 'e') >::RESULT,
                        1, "CompressedImage.name", "name",
                        m_name);

                d->read(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL5('w', 'i', 'd', 't', 'h') >::RESULT,
                        2, "CompressedImage.width", "width",
                        m_width);

                d->read(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL6('h', 'e', 'i', 'g', 'h', 't') >::RESULT,
                        3, "CompressedImage.height", "height",
                        m_height);

                d->read(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL3('b', 'p', 'p') >::RESULT,
                        4, "CompressedImage.bytesPerPixel", "bytesPerPixel",
                        m_bytesPerPixel);

                d->read(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL5('c', 's', 'i', 'z', 'e') >::RESULT,
                        5, "CompressedImage.compressedSize", "compressedSize",
                        m_compressedSize);

                OPENDAVINCI_CORE_DELETE_ARRAY(m_imageData);
                m_imageData = new uint8_t[m_compressedSize];

                d->read(CRC32 < OPENDAVINCI_CORE_STRINGLITERAL4('d', 'a', 't', 'a') >::RESULT,
                        6, "CompressedImage.data", "data",
                        m_imageData, m_compressedSize);

                return in;
            }

            const string CompressedImage::toString() const {
                stringstream sstr;
                sstr << "name = " << getName() << ", width = " << getWidth() << ", height = " << getHeight() << ", bytes per pixel = " << getBytesPerPixel() << ", compressed size = " << getCompressedSize();
                return sstr.str();
            }
        }
    }
} // core::data::image
