# GCAPI Security

Due to privacy concerns and competing interests, there must be heavy
restrictions on which users can access certain pieces of data. The first
problem to confront is authentication—who can log in and how do they do so?
The second challenge is authorization—if, when, where, and how are authenticated
users able to access specific parts of the API or pieces of data? The third
challenge we must address is how to protect the API from malicious attacks.

- [GCAPI Security](#gcapi-security)
  - [User Authentication](#user-authentication)
    - [User Authentication Flow](#user-authentication-flow)
  - [User Authorization](#user-authorization)
    - [Resource Data Models and Permissions](#resource-data-models-and-permissions)
    - [User Roles and Privileges](#user-roles-and-privileges)
  - [User Authorization Flow](#user-authorization-flow)
  - [Additional API Security Practices](#additional-api-security-practices)
    - [Key Signature Verification](#key-signature-verification)
    - [Rate Limiting](#rate-limiting)
    - [CSRF Protection](#csrf-protection)
  - [Development Security Tools](#development-security-tools)
    - [Generate App Secrets](#generate-app-secrets)
    - [GitLeaks](#gitleaks)
  - [Reporting a Vulnerability](#reporting-a-vulnerability)
  - [Resources](#resources)

----

## User Authentication

*Authentication* is complicated to develop independently and therefore the web
team recommends relying on industry standards and existing tools. Auth0 by Okta
is an Authentication platform that utilizes the OAuth2.0 authentication
standard. Using a solution like Auth0 allows users to log in through various
platforms (i.e. Google, Facebook, or Username/Password) and it allows our web
team to define and assign role-based permissions to authenticated users. By
using Auth0 by Okta, we will have access to a separate authentication database
server that is used exclusively for storing private user credentials and
authenticating the user state for the application.

### User Authentication Flow

Below is the authentication flow for a user to register and login to the
application. There are 3 primary restrictions that are enforced by the
authentication server:

1. Users must register through the Auth0 registration page with a valid email address.
2. Users must verify their email address prior to logging in and accessing the API.
   - Users will receive an email with a link to verify their email address.
   - If users do not verify their email address, they will not be able to login.
3. Users by default are assigned the role of “user” and must be granted
additional privileges by an admin to access any data.
   - New users are put into a “pending” state and cannot access the API until
   they are granted access by a user with the role of "admin".

::: mermaid
sequenceDiagram
    participant User
    participant Auth
    participant API
    User->>API: register for a user account
    API-->>Auth: redirect user to<br/>Auth0 registration page
    Auth-->>User: Auth0 registration page
    User->>Auth: submits new user registration
    loop User
        Auth->>Auth: 1. create new user<br/>2. assign default role=user<br/>3. assign default is_verified=false<br/>4. send verification email to user
    end
    Auth-->>User: redirect user to<br/>API login page
    Note over User,API: user must verify email<br/>before logging in
    User->>API: requests to login to application
    API-->>Auth: redirect user to<br/>Auth0 login page
    Auth-->>User: Auth0 login page
    User->>Auth: submits login credentials
    loop User
        Auth->>Auth: 1. verify user credentials<br/>2. checks user is_verified=true<br/>3. generate JWT
    end
    Auth-->>User: send access_token and<br/>refresh_token to access the API
:::

## User Authorization

*Authorization* is a procedure by which different users are granted privileges
depending on their ability to access the requested information. First, the API
layer will define specific permissions that are required to access specific
pieces of data.

*Permissions* are any action that may be taken on the data resource.
Permissions are tied directly to the piece of data that a user is requesting
and should describe the properties of the data. *Privileges* are specific
permissions that are assigned to a particular user.
    When a user makes an API request to create, read, update, or delete data,
first the API checks the data permissions and then it verifies if the user has
the privilege to take the desired action. Defining clear data permissions and
rules for how users are granted the privilege to access data is critical for
securing data therein.

- *Users* are able to login through a browser *Client* to request and
access a *Resource* on the *API*.
  - Users are assigned *Roles* that determine their *Privileges*.
- The *Client* is a web or mobile browser based interface by which the
*User* interacts with the *API*.
- *Authentication* is the primary process of verifying the existance and
identity of an individual user—conducted on the authorization server.
- *Authorization* (*Permissions*) is a secondary process of confirming
whether or not an authenticated user is capabile of accessing the resource
in the request.
- *User Privileges* are determined by user `role` column in the `users`
table of the databse.
- A *Resource* is a piece of data that is stored in the database.
A *Resource* is any data that may be created, read, updated, or
deleted by a user.

### Resource Data Models and Permissions

The web team documented the Resource Data Models and Permissions on GitHub.
Please refer to the [SQL README.md file](https://github.com/joeygrable94/GCAPI/blob/main/sql/README.md)
for a detailed outline of all the data models and the permissions required to
access each of the resource data models.

- Each data model typically has 5 default actions: *LIST*, *CREATE*, *READ*,
*UPDATE*, and *DELETE* (i.e. L-CRUD operations).
- Each data model permission is granted through a specific set of rules.
- If a user meets the permissions required they may be granted access to the
data. User's are granted privileges to data through the `role` assigned to
them, but other constraints may be applied to the data permissions.

### User Roles and Privileges

Privileges are granted to users through the `role` assigned to the user. By
default as soon as a new user registers, they are automatically assigned to
the role of “user”. Admins are able to grant different roles to specific users
depending on their affiliation. There are 5 roles available to be assigned
to users:

`admin` — GC Administrators can act on all aspects of the application, in
particular, they control the privileges granted to other users (i.e. which
users can access which clients' data)

`manager` — GC Managers, can act on all of the client data that they are
granted access to. Managers can also grant limited privileges to other users
to act on client data

`client` — GC Clients can access and act on their own data

`employee` — GC Employees have essential access to review and add insights
to clients they are granted access to.

`user` — Registered Users are unassociated with any GC Role or Client
and have minimal access.

## User Authorization Flow

::: mermaid
sequenceDiagram
    participant Client
    participant Auth
    participant API
    participant Permissions
    participant Resource
    Auth-->>Client: Send X-CSRF-TOKEN<br/>+ X-RATE-LIMIT
    Client->>Auth: Grant Auth:<br/>Client Credentials
    loop User
        Auth->>Auth: generate JWT
    end
    Auth-->>Client: Access Token<br/>+ Refresh Token
    Client->>API: Request Resource<br/>+ Access Token
    loop Permissions Lookup
        API-->>Permissions: Verify Token
        Permissions-->>API: Permission Granted
    end
    API->>Resource: Fetch Requested Resource
    Resource-->>Client: Protected Resource
    Note over Client,Resource: After Time:<br/>Access Token Expires
    Client->>API: Request Resource<br/>with expired Access Token
    loop Permissions Lookup
        API-->>Permissions: Verify Token
        Permissions-->>API: Permission Denied:<br/>Token Expired
    end
    API-->>Client: Access Token Expired
    API-->>API: Add Access Token to blacklist
    loop Permissions Update
        API-->>Permissions: Revoke Token
        Permissions-->>API: Token Revoked
    end
    Note over Client,Resource: After Access Expires:<br/>Refresh Authentication with Refresh Token
    Client->>Auth: Grant Auth:<br/>Refresh Token
    loop User
        Auth->>Auth: generate JWT
    end
    Auth-->>Client: New Access Token<br/>+ New Refresh Token
    Client->>API: Request Resource<br/>with new Access Token
    loop Permissions Lookup
        API-->>Permissions: Verify Token
        Permissions-->>API: Permission Granted
    end
    API->>Resource: Fetch Requested Resource
    Resource-->>Client: Protected Resource
    Note over Client,Resource: If Access Token Abused:<br/>Revoke Token
    Client->>API: Request Resource<br/>+ BAD Access Token
    loop Permissions Lookup
        API-->>Permissions: Verify Token
        Permissions-->>API: Permission Denied:<br/>Bad Token
    end
    API-->>Client: Invalid Token Error
    API-->>API: Add Access Token to revoked list
    loop Permissions Update
        API-->>Permissions: Revoke Token
        Permissions-->>API: Token Revoked
    end
    Note over Client,Resource: After Access Revoked:<br/>Re-Authenticate and Re-Authorize
    Client->>Auth: Grant Auth:<br/>Client Credentials + Refresh Token
    loop User
        Auth->>Auth: generate JWT
    end
    Auth-->>Client: New Access Token<br/>+ New Refresh Token
    Client->>API: Request Resource<br/>with new Access Token
    loop Permissions Lookup
        API-->>Permissions: Verify Token
        Permissions-->>API: Permission Granted
    end
    API->>Resource: Fetch Requested Resource
    Resource-->>Client: Protected Resource
:::

----

## Additional API Security Practices

### Key Signature Verification

- [Key Signature Verification](https://auth0.com/docs/quickstart/backend/python/01-authorization#validate-access-tokens)

### Rate Limiting

- [FastAPI Throttling Using Redis](https://sayanc20002.medium.com/api-throttling-using-redis-and-fastapi-dockerized-98a50f9495c)
- [What is rate limiting and how to implement it in Python?](https://rino-dev.com/what-is-rate-limiting-and-how-to-implement-it-in-a-python-application)

### CSRF Protection

- [What is CSRF](https://www.synopsys.com/glossary/what-is-csrf.html#:~:text=A%20CSRF%20token%20is%20a,make%20it%20difficult%20to%20guess.)
- [CSRF Protection in FastAPI](https://www.stackhawk.com/blog/csrf-protection-in-fastapi/)
- [FastAPI CSRF Protect Package](https://pypi.org/project/fastapi-csrf-protect/)
- [CSRF Protection with the FastAPI JWT Auth Package](https://indominusbyte.github.io/fastapi-jwt-auth/configuration/csrf/)

----

## Development Security Tools

### Generate App Secrets

    openssl rand -hex 32

### GitLeaks

    gitleaks detect --verbose --config=./gitleaks.toml

- [GitLeaks Repository](https://github.com/zricethezav/gitleaks)
- [GitLeaks Allow List for Inline Cases of False Positive Secrets Leak](https://github.com/zricethezav/gitleaks/issues/579)
- [GitLeaks Custom Config .toml File](https://github.com/zricethezav/gitleaks/issues/787)

## Reporting a Vulnerability

This project is not open for vulnerability reports. We DO NOT recommend using
this in production—it is only a test development project. We will not fix
vulnerabilities until this project get's pushed into production.

Contact the [Get Community, Inc. Web Team](mailto:joey@getcommunity.com)
for more information.

## Resources

- [Auth0 by Okta Authentication API Documentation](https://auth0.com/docs/api/authentication)
- [Permissions, Privileges and Scopes - What's the Difference?!](https://youtu.be/vULfBEn8N7E?si=WKJH4tOtz3d1Eu0f)
