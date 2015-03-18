%
% NOTICE: copy from rabbitmq mqtt-adaper
%


%% The contents of this file are subject to the Mozilla Public License
%% Version 1.1 (the "License"); you may not use this file except in
%% compliance with the License. You may obtain a copy of the License
%% at http://www.mozilla.org/MPL/
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and
%% limitations under the License.
%%
%% The Original Code is RabbitMQ.
%%
%% The Initial Developer of the Original Code is VMware, Inc.
%% Copyright (c) 2007-2012 VMware, Inc.  All rights reserved.
%%
-define(MQTT_PROTO_MAJOR, 3).
-define(MQTT_PROTO_MINOR, 1).

%% frame types

-define(CONNECT,      1).
-define(CONNACK,      2).
-define(PUBLISH,      3).
-define(PUBACK,       4).
-define(PUBREC,       5).
-define(PUBREL,       6).
-define(PUBCOMP,      7).
-define(SUBSCRIBE,    8).
-define(SUBACK,       9).
-define(UNSUBSCRIBE, 10).
-define(UNSUBACK,    11).
-define(PINGREQ,     12).
-define(PINGRESP,    13).
-define(DISCONNECT,  14).

%% connect return codes

-define(CONNACK_ACCEPT,      0).
-define(CONNACK_PROTO_VER,   1). %% unacceptable protocol version
-define(CONNACK_INVALID_ID,  2). %% identifier rejected
-define(CONNACK_SERVER,      3). %% server unavailable
-define(CONNACK_CREDENTIALS, 4). %% bad user name or password
-define(CONNACK_AUTH,        5). %% not authorized

-record(mqtt_frame_fixed,    {type   = 0    :: byte(),
                              dup    = false:: true | false,
                              qos    = 0    :: 0 | 1 | 2,
                              retain = false:: true | false}).

-record(mqtt_frame_connect,  {proto_ver     = ?MQTT_PROTO_MAJOR     :: 3 | 4 | 131,
                              will_retain   = false                 :: true | false,
                              will_qos      = 0                     :: 0 | 1 | 2,
                              will_flag     = false                 :: true | false,
                              clean_sess    = false                 :: true | false,
                              keep_alive    = 60                    :: non_neg_integer(),
                              client_id     = ""                    :: string() | missing | empty,
                              will_topic                            :: undefined | string(),
                              will_msg                              :: undefined | binary(),
                              username                              :: undefined | string(),
                              password                              :: undefined | string()}).

-record(mqtt_frame_connack,  {return_code   :: 0 | 1 | 2 | 3 | 4 | 5}).

-record(mqtt_frame_publish,  {topic_name    :: string(),
                              message_id    :: undefined | 1..65535}).

-record(mqtt_topic,          {name          :: string(),
                              qos           :: 0 | 1 | 2}).

-record(mqtt_frame_subscribe,{message_id    :: 1..65535,
                              topic_table   :: [string() | #mqtt_topic{}]}).

-record(mqtt_frame_suback,   {message_id    :: 1..65535,
                              qos_table = []:: [0 | 1 | 2]}).

-record(mqtt_frame, {fixed                  :: #mqtt_frame_fixed{},
                     variable               :: #mqtt_frame_connect{}
                                             | #mqtt_frame_connack{}
                                             | #mqtt_frame_publish{}
                                             | #mqtt_frame_subscribe{}
                                             | #mqtt_frame_suback{},
                     payload                :: binary()}).


-record(mqtt_frame_other,    {other}).



