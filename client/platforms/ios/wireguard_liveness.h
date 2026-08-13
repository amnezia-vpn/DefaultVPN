#ifndef WIREGUARD_LIVENESS_H
#define WIREGUARD_LIVENESS_H

#include <cstdint>

namespace amnezia::ios
{

    enum class WireGuardLiveness {
        AwaitingHandshake,
        Alive,
        Stale,
        TelemetryUnavailable,
    };

    constexpr std::int64_t kDefaultStaleAfterSec = 240;
    constexpr std::int64_t kAllowedClockSkewSec = 60;

    inline WireGuardLiveness evaluateWireGuardLiveness(bool handshakeConfirmed, std::int64_t connectionStartedAtSec,
                                                       std::int64_t nowSec, std::int64_t lastHandshakeSec,
                                                       std::uint64_t previousRxBytes, std::uint64_t previousTxBytes,
                                                       std::uint64_t rxBytes, std::uint64_t txBytes,
                                                       std::int64_t staleAfterSec = kDefaultStaleAfterSec) noexcept
    {
        const bool trafficAdvanced = rxBytes > previousRxBytes || txBytes > previousTxBytes;
        const bool handshakeTimestampValid = lastHandshakeSec > 0 && lastHandshakeSec <= nowSec + kAllowedClockSkewSec;

        if (!handshakeConfirmed) {
            if ((handshakeTimestampValid && lastHandshakeSec >= connectionStartedAtSec) || trafficAdvanced) {
                return WireGuardLiveness::Alive;
            }
            return WireGuardLiveness::AwaitingHandshake;
        }

        if (trafficAdvanced) {
            return WireGuardLiveness::Alive;
        }
        if (!handshakeTimestampValid) {
            return WireGuardLiveness::TelemetryUnavailable;
        }
        if (nowSec - lastHandshakeSec > staleAfterSec) {
            return WireGuardLiveness::Stale;
        }
        return WireGuardLiveness::Alive;
    }

} // namespace amnezia::ios

#endif // WIREGUARD_LIVENESS_H
