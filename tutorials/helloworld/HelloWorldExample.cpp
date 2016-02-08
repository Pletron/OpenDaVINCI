/**
 * OpenDaVINCI - Tutorial.
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

#include <iostream>

#include "HelloWorldExample.h"

using namespace std;

// We add some of OpenDaVINCI's namespaces for the sake of readability.
using namespace core::base::module;

HelloWorldExample::HelloWorldExample(const int32_t &argc, char **argv) :
    TimeTriggeredConferenceClientModule(argc, argv, "HelloWorldExample")
    {}

HelloWorldExample::~HelloWorldExample() {}

void HelloWorldExample::setUp() {
    cout << "This method is called before the component's body is executed." << endl;
}

void HelloWorldExample::tearDown() {
    cout << "This method is called after the program flow returns from the component's body." << endl;
}

coredata::dmcp::ModuleExitCodeMessage::ModuleExitCode HelloWorldExample::body() {
    cout << "Hello OpenDaVINCI World!" << endl;

    while (getModuleStateAndWaitForRemainingTimeInTimeslice() == coredata::dmcp::ModuleStateMessage::RUNNING) {
        cout << "Inside the main processing loop." << endl;
    }

    return coredata::dmcp::ModuleExitCodeMessage::OKAY;
}

