#include "wireguard_liveness.h"

#include <cassert>

using amnezia::ios::evaluateWireGuardLiveness;
using amnezia::ios::WireGuardLiveness;

int main()
{
    constexpr std::int64_t startedAt = 1'000;
    constexpr std::int64_t now = 1'300;

    assert(evaluateWireGuardLiveness(false, startedAt, now, 900, 0, 0, 0, 0) == WireGuardLiveness::AwaitingHandshake);
    assert(evaluateWireGuardLiveness(false, startedAt, now, 1'001, 0, 0, 0, 0) == WireGuardLiveness::Alive);
    assert(evaluateWireGuardLiveness(true, startedAt, now, 1'100, 0, 0, 0, 0) == WireGuardLiveness::Alive);
    assert(evaluateWireGuardLiveness(true, startedAt, now, 1'000, 0, 0, 0, 0) == WireGuardLiveness::Stale);
    assert(evaluateWireGuardLiveness(true, startedAt, now, 1'000, 10, 20, 11, 20) == WireGuardLiveness::Alive);
    assert(evaluateWireGuardLiveness(true, startedAt, now, -2, 10, 20, 10, 20) == WireGuardLiveness::TelemetryUnavailable);
    assert(evaluateWireGuardLiveness(true, startedAt, now, now + 61, 0, 0, 0, 0)
           == WireGuardLiveness::TelemetryUnavailable);

    return 0;
}
