#ifndef IPCSERVER_H
#define IPCSERVER_H

#include <QLocalServer>
#include <QObject>
#include <QRemoteObjectNode>
#include <QJsonObject>
#include "../client/daemon/interfaceconfig.h"

#include "ipc.h"
#include "ipcserverprocess.h"
#include "ipctun2socksprocess.h"

#include "rep_ipc_interface_source.h"
#include "rep_ipc_process_tun2socks_source.h"

class IpcServer : public IpcInterfaceSource
{
public:
    explicit IpcServer(QObject *parent = nullptr);
    virtual int createPrivilegedProcess() override;

    virtual int routeAddList(const QString &gw, const QStringList &ips) override;
    virtual bool clearSavedRoutes() override;
    virtual bool routeDeleteList(const QString &gw, const QStringList &ips) override;
    virtual void flushDns() override;
    virtual void resetIpStack() override;
    virtual bool checkAndInstallDriver() override;
    virtual QStringList getTapList() override;
    virtual void cleanUp() override;
    virtual void clearLogs() override;
    virtual void setLogsEnabled(bool enabled) override;
    virtual bool createTun(const QString &dev, const QString &subnet) override;
    virtual bool deleteTun(const QString &dev) override;
    virtual void StartRoutingIpv6() override;
    virtual void StopRoutingIpv6() override;
    virtual bool enablePeerTraffic(const QJsonObject &configStr) override;
    virtual bool enableKillSwitch(const QJsonObject &excludeAddr, int vpnAdapterIndex) override;
    virtual bool disableKillSwitch() override;
    virtual bool updateResolvers(const QString& ifname, const QList<QHostAddress>& resolvers) override;

private:
    int m_localpid = 0;

    struct ProcessDescriptor {
        ProcessDescriptor (QObject *parent = nullptr) {
            serverNode = QSharedPointer<QRemoteObjectHost>(new QRemoteObjectHost(parent));
            ipcProcess = QSharedPointer<IpcServerProcess>(new IpcServerProcess(parent));
            tun2socksProcess = QSharedPointer<IpcProcessTun2Socks>(new IpcProcessTun2Socks(parent));
            localServer = QSharedPointer<QLocalServer>(new QLocalServer(parent));
        }

        QSharedPointer<IpcServerProcess> ipcProcess;
        QSharedPointer<IpcProcessTun2Socks> tun2socksProcess;
        QSharedPointer<QRemoteObjectHost> serverNode;
        QSharedPointer<QLocalServer> localServer;
    };

    QMap<int, ProcessDescriptor> m_processes;
};

#endif // IPCSERVER_H
