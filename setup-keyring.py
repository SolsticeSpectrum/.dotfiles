#!/usr/bin/env python3
"""Create default gnome-keyring. Will prompt for a password on first run."""
import gi
gi.require_version('Secret', '1')
from gi.repository import Secret
schema = Secret.Schema.new('org.freedesktop.Secret.Generic',
    Secret.SchemaFlags.NONE, {})
Secret.password_store_sync(schema, {}, Secret.COLLECTION_DEFAULT,
    'test', 'test', None)
Secret.password_clear_sync(schema, {}, None)
print('Default keyring created')
