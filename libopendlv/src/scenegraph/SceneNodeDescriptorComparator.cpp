/**
 * OpenDLV - Simulation environment
 * Copyright (C) 2008 - 2015 Christian Berger, Bernhard Rumpe
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include <string>

#include "opendlv/scenegraph/SceneNodeDescriptorComparator.h"

namespace opendlv {
    namespace scenegraph {

        SceneNodeDescriptorComparator::SceneNodeDescriptorComparator() {}

        SceneNodeDescriptorComparator::SceneNodeDescriptorComparator(const SceneNodeDescriptorComparator &/*obj*/) {}

        SceneNodeDescriptorComparator::~SceneNodeDescriptorComparator() {}

        SceneNodeDescriptorComparator& SceneNodeDescriptorComparator::operator=(const SceneNodeDescriptorComparator &/*obj*/) {
            return (*this);
        }

        bool SceneNodeDescriptorComparator::operator()(const SceneNodeDescriptor &snd1, const SceneNodeDescriptor &snd2) const {
            return snd1.getName().compare(snd2.getName()) < 0;
        }

    }
} // opendlv::scenegraph
