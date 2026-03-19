#!/bin/bash

echo "Allow plain login for testing..."
wp option patch delete planet4_features enforce_sso || true
