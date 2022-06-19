#!/bin/bash
grep -m 1 "stopped in" <(tail -n 0 -f /opt/wildfly/standalone/log/server.log );

