# This file is copied from giocci/ as it is to configure Giocci features.

import Config
import Dotenvy

source!([".env", System.get_env()])

config :giocci, :giocci_zenoh,
  # The node name of your application
  my_client_node_name: env!("MY_CLIENT_NODE_NAME", :string, "client1"),
  # The nodes' name for Giocci relays
  relay_node_list:
    env!("RELAY_NODE_LIST", :string, "relay1,relay9, relay3") |> String.split(~r/[ ,]+/)
