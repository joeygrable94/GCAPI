# GCAPI: Resource Data Models and Permissions

The GC Client Data Portal contains a few core data models with the ability to
grow and scale. Below is an outline of the data models and how they relate to
one another; it aims to answer the following questions for each:

- What data is being modeled?
- Where is the data stored?
- How should the data be formatted in its storage location
  - data type, size, and validation?
- Why is the data valuable or significant?
- Who has access to the data?
- When can users create, read, update, or delete the data?

## Schema Diagram

![schema-diagram.png](./schema-diagram.png)

<dl>
    <dt>blue</dt>
    <dd>client-specific data:<br/>Client</dd>
    <dt>green</dt>
    <dd>user-specific data:
    <br/>User, Ipaddress, Note, UserIpaddress, UserClient</dd>
    <dt>violet</dt>
    <dd>third-party API key/connection data:
    <br/>GoogleCloud, Sharpspring, BDXFeed</dd>
    <dt>pink</dt>
    <dd>website data:
    <br/>Website, WebsiteMap, WebsitePage, WebsiteKeywordcorpus,
    WebsitePagespeedinsights, ClientWebsite</dd>
    <dt>indigo</dt>
    <dd>website analytics and search console data:
    <br/>GoogleSearchConsole, GSCCountry, GSCDevice, GSCPage, GSCQuery,
    GSCSearchappearance, GoogleAnalytics4, GA4Steam, GoogleUniversalAnalytics, GUAView</dd>
    <dt>orange</dt>
    <dd>GC Fly Tours and GCFT analytics data:
    <br/>GCFlyTour, GCFTSnap, GCFTSnapView, GCFTSnapActiveduration,
    GCFTSnapHotspotclick, GCFTSnapTrafficsource, GCFTSnapBrowserreport</dd>
    <dt>brown</dt>
    <dd>AWS S3 bucket storage and file data:<br/>ClientBucket, FileAsset</dd>
    <dt>black</dt>
    <dd>application worker tasks/services:<br/>GeoCoord</dd>
</dl>

## Data Models

- [GCAPI: Resource Data Models and Permissions](#gcapi-resource-data-models-and-permissions)
  - [Schema Diagram](#schema-diagram)
  - [Data Models](#data-models)
    - [Base Model](#base-model)
    - [User](#user)
      - [Permission: User Me (i.e. Current User)](#permission-user-me-ie-current-user)
      - [Permission: Read User](#permission-read-user)
      - [Permission: Update User](#permission-update-user)
      - [Permission: Delete User](#permission-delete-user)
    - [Ipaddress](#ipaddress)
    - [User Ipaddress](#user-ipaddress)
    - [Note](#note)
    - [Client](#client)
      - [Permission: Create Client](#permission-create-client)
      - [Permission: Read Client](#permission-read-client)
      - [Permission: Update Client](#permission-update-client)
      - [Permission: Delete Client](#permission-delete-client)
    - [User Client](#user-client)
    - [Client Website](#client-website)
    - [Client Report](#client-report)
    - [Client Report Note](#client-report-note)
    - [Client Bucket](#client-bucket)
    - [File Asset](#file-asset)
    - [GeoCoord](#geocoord)
    - [Sharpspring](#sharpspring)
    - [BDX Feed](#bdx-feed)
    - [Website](#website)
    - [Website Map](#website-map)
    - [Website Page](#website-page)
    - [Website Page Speed Insight](#website-page-speed-insight)
    - [Website Keyword Corpus](#website-keyword-corpus)
    - [Google Analytics 4](#google-analytics-4)
    - [Google Analytics 4: Stream](#google-analytics-4-stream)
    - [Google Search Console](#google-search-console)
    - [Google Search Console: Country, Device, Page, Query, SearchAppearance](#google-search-console-country-device-page-query-searchappearance)
    - [GC Fly Tour](#gc-fly-tour)
    - [GC Fly Tour Snap](#gc-fly-tour-snap)
    - [GC Fly Tour Snap: Active Duration](#gc-fly-tour-snap-active-duration)
    - [GC Fly Tour Snap: Browser Report](#gc-fly-tour-snap-browser-report)
    - [GC Fly Tour Snap: Hotspot Click](#gc-fly-tour-snap-hotspot-click)
    - [GC Fly Tour Snap: Traffic Source](#gc-fly-tour-snap-traffic-source)
    - [GC Fly Tour Snap: View](#gc-fly-tour-snap-view)

### Base Model

    Table "gcapidb"."TABLE_NAME" {
        "id" CHAR(32) [not null]
        "created_on" DATETIME [not null, default: `now()`]
        "updated_on" DATETIME [not null, default: `now()`, onupdate: `now()`]

        Indexes {
            id [unique, name: "id_UNIQUE"]
        }
    }

For the sake of being brief, all tables adopt the following base model. The
“id” field is the primary value used in lookups for any associated data models.

### User

    Table "gcapidb"."user" {
        "auth_id" VARCHAR(255) [pk, not null]
        "email" VARCHAR(320) [not null]
        "is_active" TINYINT(1) [not null, default: 1]
        "is_verified" TINYINT(1) [not null, default: 0]
        "is_superuser" TINYINT(1) [not null, default: 0]
        "roles" JSON [not null, default: "[\"user\"]"]

        Indexes {
            auth_id [unique, name: "auth_id_UNIQUE"]
            email [unique, name: "email_UNIQUE"]
        }
    }

The user data model is essential in determining the privileges that users have,
and by extension what data they are authorized to access through the API.

As described in the previous sections, the Authentication will be handled by
the Auth0 database server and therefore our application database will not store
any passwords. The application database will only store information about the
privileges granted to the user and minimal personal info. NO credentials unique
to the user will be stored on the application database. The only personal
information stored on the application database is the email address and this
field cannot be updated by any user. The auth_id field is a unique identifier
provided by the authentication database and cannot be changed by any user.

The user privileges are predominantly controlled by the role field in the
database. The user data model includes a few flags: is_active, is_verified,
is_superuser.

#### Permission: User Me (i.e. Current User)

- there is no API endpoint to CREATE an authenticated user
  - only people with credentials to the Auth0 account can manually create
    a new user in the authentication database
- any user may register and login to the authentication database
- after a user’s first authenticated, their privileges are created
  in the application database
  - by default all new users are assigned the role=user
  - by default all new user have the flag is_active=True
  - by default all new user have the flag is_verified=False
  - by default all new user have the flag is_superuser=False

#### Permission: Read User

- a user can READ their own user data
- a user can see certain privilege flags depending on the user’s role
  - role=admin can see all flags, including is_superuser
  - role=manager|client|employee can only see is_active and is_verified

#### Permission: Update User

- a user can UPDATE limited fields of their own data
  - a user can UPDATE their flag is_verified=True by validating a verification
    token provided through an email
  - a user can have their flag is_verified UPDATEd, if the Auth0 authentication
    database provides an alternate value
- users with role=manager can UPDATE the:
  - role of other users with role=client|employee|user,
    but not to role=admin
  - flags of users with role==client|employee|user,
    but cannot set the flag is_superuser=True
- only users with role=admin can UPDATE user privileges without restriction
  - assign any user the role=admin
  - update any flag of any user
- only one user can have flag is_superuser=True (the admin 👑 of admin ⚔️)
  - only user with flag is_superuser can relinquish their administrative-admin
    role to one other user in the application database

#### Permission: Delete User

- only users with role=admin can DELETE users

### Ipaddress

    Table "gcapidb"."ipaddress" {
        "address" VARCHAR(40) [pk, not null]
        "isp" VARCHAR(255) [not null, default: "unknown"]
        "location" TEXT [not null, default: "unknown"]
        "geocoord_id" CHAR(32)

        Indexes {
            address [unique, name: "address_UNIQUE"]
            geocoord_id [name: "geocoord_id_idx"]
        }
    }

### User Ipaddress

    Table "gcapidb"."user_ipaddress" {
        "ipaddress_id" CHAR(32) [not null]
        "user_id" CHAR(32) [not null]

        Indexes {
            (ipaddress_id, user_id) [pk]
            id [unique, name: "id_UNIQUE"]
            user_id [name: "user_id_idx"]
            ipaddress_id [name: "ipaddress_id_idx"]
        }
    }

### Note

    Table "gcapidb"."note" {
        "title" VARCHAR(96) [pk, not null]
        "description" TEXT(5000)
        "user_id" CHAR(32) [not null]

        Indexes {
            title [unique, name: "title_UNIQUE"]
            user_id [name: "user_id_idx"]
        }
    }

### Client

    Table "gcapidb"."client" {
        "title" VARCHAR(96) [pk, not null]
        "description" TEXT(5000)

        Indexes {
            title [unique, name: "title_UNIQUE"]
        }
    }

#### Permission: Create Client

#### Permission: Read Client

#### Permission: Update Client

#### Permission: Delete Client

### User Client

    Table "gcapidb"."user_client" {
        "client_id" CHAR(32) [not null]
        "user_id" CHAR(32) [not null]

        Indexes {
            (client_id, user_id) [pk]
            client_id [name: "client_id_idx"]
            user_id [name: "user_id_idx"]
        }
    }

### Client Website

    Table "gcapidb"."client_website" {
        "client_id" CHAR(32) [not null]
        "website_id" CHAR(32) [not null]

        Indexes {
        (client_id, website_id) [pk]
            website_id [name: "website_id_idx"]
            client_id [name: "client_id_idx"]
        }
    }

### Client Report

    Table "gcapidb"."client_report" {
        "title" VARCHAR(96) [pk, not null]
        "url" VARCHAR(2048) [not null]
        "description" TEXT(5000)
        "keys" BLOB

        Indexes {
            title [unique, name: "title_UNIQUE"]
        }
    }

### Client Report Note

    Table "gcapidb"."client_report_note" {
        "client_report_id" CHAR(32) [not null]
        "note_id" CHAR(32) [not null]

        Indexes {
            (client_report_id, note_id) [pk]
            client_report_id [name: "client_report_id_idx1"]
            note_id [name: "note_id_idx"]
        }
    }

### Client Bucket

    Table "gcapidb"."client_bucket" {
        "description" TEXT(5000)
        "bucket_name" VARCHAR(100) [pk, not null]
        "object_key" VARCHAR(2048) [not null]
        "client_id" CHAR(32) [not null]

        Indexes {
            client_id [name: "client_id_idx"]
        }
    }

### File Asset

    Table "gcapidb"."file_asset" {
        "name" VARCHAR(96) [pk, not null]
        "extension" VARCHAR(255) [not null]
        "size_kb" INT [not null]
        "title" VARCHAR(96) [not null]
        "caption" VARCHAR(150)
        "keys" BLOB
        "is_private" TINYINT(1) [not null, default: 0]
        "user_id" CHAR(32) [not null]
        "bucket_id" CHAR(32) [not null]
        "client_id" CHAR(32) [not null]
        "geocoord_id" CHAR(32)
        "bdx_feed_id" CHAR(32)

        Indexes {
            name [unique, name: "name_UNIQUE"]
            user_id [name: "user_id_idx"]
            bucket_id [name: "bucket_id_idx"]
            client_id [name: "client_id_idx"]
            geocoord_id [name: "geocoord_id_idx"]
            bdx_feed_id [name: "bdx_feed_id_idx"]
        }
    }

### GeoCoord

    Table "gcapidb"."geocoord" {
        "address" VARCHAR(255) [pk, not null]
        "latitude" FLOAT [not null]
        "longitude" FLOAT [not null]

        Indexes {
            address [unique, name: "address_UNIQUE"]
        }
    }

### Sharpspring

    Table "gcapidb"."sharpspring" {
        "hashed_api_key" VARCHAR(64) [not null]
        "hashed_secret_key" VARCHAR(64) [not null]
        "client_id" CHAR(32) [not null]

        Indexes {
            client_id [name: "client_id_idx"]
        }
    }

### BDX Feed

    Table "gcapidb"."bdx_feed" {
        "username" VARCHAR(255) [pk, not null]
        "password" VARCHAR(255) [not null]
        "serverhost" VARCHAR(255) [not null]
        "client_id" CHAR(32) [not null]

        Indexes {
            username [unique, name: "username_UNIQUE"]
        }
    }

### Website

    Table "gcapidb"."website" {
        "domain" VARCHAR(255) [pk, not null]
        "is_secure" TINYINT(1) [not null, default: 0]

        Indexes {
            domain [unique, name: "domain_UNIQUE"]
        }
    }

### Website Map

    Table "gcapidb"."website_map" {
        "url" VARCHAR(2048) [not null]
        "website_id" CHAR(32) [not null]

        Indexes {
            website_id [name: "website_id_idx"]
        }
    }

### Website Page

    Table "gcapidb"."website_page" {
        "url" VARCHAR(2048) [not null]
        "status" INT [not null]
        "priority" FLOAT [not null]
        "last_modified" DATETIME
        "change_frequency" VARCHAR(64)
        "website_id" CHAR(32) [not null]
        "sitemap_id" CHAR(32)

        Indexes {
            website_id [name: "website_id_idx"]
            sitemap_id [name: "sitemap_id_idx"]
        }
    }

### Website Page Speed Insight

    Table "gcapidb"."website_pagespeedinsights" {
        "strategy" VARCHAR(16) [not null]
        "ps_weight" INT [not null, default: 100]
        "ps_grade" FLOAT [not null, default: 0]
        "ps_value" VARCHAR(4) [not null, default: "0%"]
        "ps_unit" VARCHAR(16) [not null, default: "percent"]
        "fcp_weight" INT [not null, default: 10]
        "fcp_grade" FLOAT [not null, default: 0]
        "fcp_value" FLOAT [not null, default: 0]
        "fcp_unit" VARCHAR(16) [not null, default: "miliseconds"]
        "lcp_weight" INT [not null, default: 25]
        "lcp_grade" FLOAT [not null, default: 0]
        "lcp_value" FLOAT [not null, default: 0]
        "lcp_unit" VARCHAR(16) [not null, default: "miliseconds"]
        "cls_weight" INT [not null, default: 15]
        "cls_grade" FLOAT [not null, default: 0]
        "cls_value" FLOAT [not null, default: 0]
        "cls_unit" VARCHAR(16) [not null, default: "unitless"]
        "si_weight" INT [not null, default: 10]
        "si_grade" FLOAT [not null, default: 0]
        "si_value" FLOAT [not null, default: 0]
        "si_unit" VARCHAR(16) [not null, default: "miliseconds"]
        "tbt_weight" INT [not null, default: 30]
        "tbt_grade" FLOAT [not null, default: 0]
        "tbt_value" FLOAT [not null, default: 0]
        "tbt_unit" VARCHAR(16) [not null, default: "miliseconds"]
        "website_id" CHAR(32) [not null]
        "page_id" CHAR(32) [not null]

        Indexes {
            website_id [name: "website_id_idx"]
            page_id [name: "page_id_idx"]
        }
    }

### Website Keyword Corpus

    Table "gcapidb"."website_keywordcorpus" {
        "corpus" LONGTEXT [not null]
        "rawtext" LONGTEXT [not null]
        "website_id" CHAR(32) [not null]
        "page_id" CHAR(32) [not null]

        Indexes {
            website_id [name: "website_id_idx"]
            page_id [name: "page_id_idx"]
        }
    }

### Google Analytics 4

    Table "gcapidb"."go_a4" {
        "title" VARCHAR(255) [not null]
        "measurement_id" CHAR(16) [pk, not null]
        "property_id" CHAR(16) [not null]
        "client_id" CHAR(32) [not null]
        "website_id" CHAR(32) [not null]

        Indexes {
            title [unique, name: "title_UNIQUE"]
            measurement_id [unique, name: "measurement_id_UNIQUE"]
            client_id [name: "client_id_idx"]
            website_id [name: "website_id_idx"]
        }
    }

### Google Analytics 4: Stream

    Table "gcapidb"."go_a4_stream" {
        "title" VARCHAR(255) [not null]
        "stream_id" CHAR(16) [pk, not null]
        "ga4_id" CHAR(32) [not null]

        Indexes {
            title [unique, name: "title_UNIQUE"]
            stream_id [unique, name: "stream_id_UNIQUE"]
            ga4_id [name: "ga4_id_idx"]
        }
    }

### Google Search Console

    Table "gcapidb"."go_sc" {
        "title" VARCHAR(255) [not null]
        "client_id" CHAR(32) [not null]
        "website_id" CHAR(32) [not null]

        Indexes {
            title [unique, name: "title_UNIQUE"]
            client_id [name: "client_id_idx"]
            website_id [name: "website_id_idx"]
        }
    }

### Google Search Console: Country, Device, Page, Query, SearchAppearance

    Table "gcapidb"."go_sc_DATA_NAME" {
        "keys" BLOB [not null]
        "clicks" INT [not null]
        "impressions" INT [not null]
        "ctr" FLOAT [not null]
        "position" FLOAT [not null]
        "date_start" DATETIME [not null]
        "date_end" DATETIME [not null]
        "gsc_id" CHAR(32) [not null]

        Indexes {
            id [unique, name: "id_UNIQUE"]
            gsc_id [name: "gsc_id_idx"]
        }
    }

### GC Fly Tour

    Table "gcapidb"."gcft" {
        "group_name" VARCHAR(255) [not null]
        "group_slug" VARCHAR(12) [pk, not null]
        "client_id" CHAR(32) [not null]

        Indexes {
            client_id [name: "client_id_idx"]
        }
    }

### GC Fly Tour Snap

    Table "gcapidb"."gcft_snap" {
        "snap_name" VARCHAR(255) [not null]
        "snap_slug" VARCHAR(12) [pk, not null]
        "altitude" INT
        "gcft_id" CHAR(32) [not null]
        "image_id" CHAR(32) [not null]
        "geocoord_id" CHAR(32) [not null]

        Indexes {
            gcft_id [name: "gcft_id_idx"]
            image_id [name: "image_id_idx"]
            geocoord_id [name: "geocoord_id_idx"]
            snap_slug [unique, name: "snap_slug_UNIQUE"]
        }
    }

### GC Fly Tour Snap: Active Duration

    Table "gcapidb"."gcft_snap_activeduration" {
        "session_id" CHAR(32) [not null]
        "active_seconds" INT [not null]
        "visit_date" DATETIME [not null]
        "gcft_id" CHAR(32) [not null]
        "snap_id" CHAR(32) [not null]

        Indexes {
            gcft_id [name: "gcft_id_idx"]
            snap_id [name: "snap_id_idx"]
        }
    }

### GC Fly Tour Snap: Browser Report

    Table "gcapidb"."gcft_snap_browserreport" {
        "session_id" CHAR(32) [not null]
        "browser" VARCHAR(255)
        "browser_version" VARCHAR(255)
        "platform" VARCHAR(255)
        "platform_version" VARCHAR(255)
        "desktop" TINYINT(1)
        "tablet" TINYINT(1)
        "mobile" TINYINT(1)
        "city" VARCHAR(255)
        "country" VARCHAR(255)
        "state" VARCHAR(255)
        "language" VARCHAR(255)
        "visit_date" DATETIME [not null]
        "gcft_id" CHAR(32) [not null]
        "snap_id" CHAR(32) [not null]

        Indexes {
            gcft_id [name: "gcft_id_idx"]
            snap_id [name: "snap_id_idx"]
        }
    }

### GC Fly Tour Snap: Hotspot Click

    Table "gcapidb"."gcft_snap_hotspotclick" {
        "session_id" CHAR(32) [not null]
        "reporting_id" CHAR(32)
        "hotspot_type_name" VARCHAR(32)
        "hotspot_content" LONGTEXT
        "hotspot_icon_name" VARCHAR(255)
        "hotspot_name" VARCHAR(255)
        "hotspot_user_icon_name" VARCHAR(255)
        "linked_snap_name" VARCHAR(255)
        "snap_file_name" VARCHAR(255)
        "icon_color" VARCHAR(32)
        "bg_color" VARCHAR(32)
        "text_color" VARCHAR(32)
        "hotspot_update_date" DATETIME [not null]
        "click_date" DATETIME [not null]
        "gcft_id" CHAR(32) [not null]
        "snap_id" CHAR(32) [not null]

        Indexes {
            gcft_id [name: "gcft_id_idx"]
            snap_id [name: "snap_id_idx"]
        }
    }

### GC Fly Tour Snap: Traffic Source

    Table "gcapidb"."gcft_snap_trafficsource" {
        "session_id" CHAR(32) [not null]
        "referrer" VARCHAR(2048) [not null]
        "utm_campaign" VARCHAR(255)
        "utm_content" VARCHAR(255)
        "utm_medium" VARCHAR(255)
        "utm_source" VARCHAR(255)
        "utm_term" VARCHAR(255)
        "visit_date" DATETIME [not null]
        "gcft_id" CHAR(32) [not null]
        "snap_id" CHAR(32) [not null]

        Indexes {
            gcft_id [name: "gcft_id_idx"]
            snap_id [name: "snap_id_idx"]
        }
    }

### GC Fly Tour Snap: View

    Table "gcapidb"."gcft_snap_view" {
        "session_id" CHAR(32) [not null]
        "view_date" DATETIME [not null]
        "gcft_id" CHAR(32) [not null]
        "snap_id" CHAR(32) [not null]

        Indexes {
            gcft_id [name: "gcft_id_idx"]
            snap_id [name: "snap_id_idx"]
        }
    }
