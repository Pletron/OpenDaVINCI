/**
 * OpenDaVINCI - Portable middleware for distributed components.
 * Copyright (C) 2008 - 2015 Christian Berger, Bernhard Rumpe
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

#ifndef OPENDAVINCI_DMCP_CONNECTION_SERVER_H_
#define OPENDAVINCI_DMCP_CONNECTION_SERVER_H_

#include "core/opendavinci.h"
#include "core/base/Mutex.h"
#include "core/io/ConnectionAcceptor.h"
#include "core/io/ConnectionAcceptorListener.h"

namespace coredata { namespace dmcp { class ServerInformation; } }
namespace core { namespace dmcp { class ModuleConfigurationProvider; } }
namespace core { namespace io { class Connection; } }
namespace core { template <class T> class SharedPointer; }

namespace core {
    namespace dmcp {
        namespace connection {

class ConnectionHandler;

            using namespace std;

            class OPENDAVINCI_API Server : protected core::io::ConnectionAcceptorListener {
                private:
                    /**
                     * "Forbidden" copy constructor. Goal: The compiler should warn
                     * already at compile time for unwanted bugs caused by any misuse
                     * of the copy constructor.
                     */
                    Server(const Server &);

                    /**
                     * "Forbidden" assignment operator. Goal: The compiler should warn
                     * already at compile time for unwanted bugs caused by any misuse
                     * of the assignment operator.
                     */
                    Server& operator=(const Server &);

                public:
                    Server(const coredata::dmcp::ServerInformation &serverInformation,
                           ModuleConfigurationProvider &configProvider);
                    virtual ~Server();

                    void setConnectionHandler(ConnectionHandler* connectionHandler);

                protected:
                    virtual void onNewConnection(core::SharedPointer<core::io::Connection> connection);

                    core::base::Mutex m_configProviderMutex;
                    ModuleConfigurationProvider& m_configProvider;

                    core::base::Mutex m_connectionHandlerMutex;
                    ConnectionHandler* m_connectionHandler;

                    core::io::ConnectionAcceptor m_acceptor;
            };
        }
    }
} // core::dmcp

#endif  /*OPENDAVINCI_DMCP_CONNECTION_SERVER_H_*/
