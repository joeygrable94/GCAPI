# GCAPI Security

- [GCAPI Security](#gcapi-security)
  - [Reporting a Vulnerability](#reporting-a-vulnerability)
  - [Generate App Secrets](#generate-app-secrets)
  - [User Authentication and Authorization](#user-authentication-and-authorization)
    - [Authorization: Resource Data Models and Permissions](#authorization-resource-data-models-and-permissions)
    - [Authorizaion: User Roles and Privileges](#authorizaion-user-roles-and-privileges)
    - [Authentication and Authorization Flow](#authentication-and-authorization-flow)
  - [Testing Tools](#testing-tools)
    - [GitLeaks](#gitleaks)
      - [References](#references)

## Reporting a Vulnerability

This project is not open for vulnerability reports. We DO NOT recommend using
this in production—it is only a test development project. We will not fix
vulnerabilities until this project get's pushed into production.

## Generate App Secrets

Use `openssl rand -hex 32` to generate a secret key.

----

## User Authentication and Authorization

Due to privacy concerns and competing interests, there must be heavy
restrictions on which users can access certain pieces of data. The first
problem to confront is authentication—who can log in and how do they do so?
The second challenge is authorization—if, when, where, and how are authenticated
users able to access specific parts of the API or pieces of data?

Authentication is complicated to develop independently and therefore the web
team recommends relying on industry standards and existing tools. Auth0 by Okta
is an Authentication platform that utilizes the OAuth2.0 authentication
standard. Using a solution like Auth0 allows users to log in through various
platforms (i.e. Google, Facebook, or Username/Password) and it allows our web
team to define and assign role-based permissions to authenticated users. By
using Auth0 by Okta, we will have access to a separate authentication database
server that is used exclusively for storing private user credentials and
authenticating the user state for the application.

Authorization is a procedure by which different users are granted privileges
depending on their ability to access the requested information. First, the API
layer will define specific permissions that are required to access specific
pieces of data.

**Permissions** are any action that may be taken on the data resource. Permissions are tied directly to the piece of data that a user is requesting and should describe the properties of the data. Privileges are specific permissions that are assigned to a particular user. When a user makes an API request to create, read, update, or delete data, first the API checks the data permissions and then it verifies if the user has the privilege to take the desired action. Defining clear data permissions and rules for how users are granted the privilege to access data is critical for securing data therein.

- **Users** are able to login through a browser **Client** to request and access a **Resource** on the **API**.
- The **Client** is a web or mobile browser based interface by which the **User** interacts with the **API**.
- **Authentication** is the primary process of verifying the existance and identity of an individual user—conducted on the authorization server.
- **Authorization** (**Permissions**) is a secondary process of confirming whether or not an authenticated user is capabile of accessing the resource in the request.
- **User Permissions** are stored in the user table in the scopes column of the databse.
- A **Resource** is a piece of data that is stored in the database. A **Resource** is any data that can be created, read, updated, or deleted by a user.

### Authorization: Resource Data Models and Permissions

The web team documented the Resource Data Models and Permissions on GitHub. Please refer to the [SQL README.md file](https://github.com/joeygrable94/GCAPI/blob/main/sql/README.md) for a detailed outline of all the data models and the permissions associated with each.

- Each data model typically has 4 default actions: CREATE, READ, UPDATE, and DELETE (i.e. CRUD operations).
- Each data model permission is granted through a specific set of rules.
- If a user meets the permissions required they may be granted access to the data.
- Additional constraints are placed on users depending on what roles are assigned to them.

### Authorizaion: User Roles and Privileges

Privileges are granted to users through the `role` assigned to the user. By default as soon as a new user registers, they are automatically assigned to the role of “user”. After a verification process, admins are able to grant different roles to specific users depending on their affiliation. There are 5 roles available to be assigned to users:

`admin` — GC Administrators can act on all aspects of the application, in particular, they control the privileges granted to other users (i.e. which users can access which clients' data)

`manager` — GC Managers, can act on all of the client data that they are granted access to. Managers can also grant limited privileges to other users to act on client data

`client` — GC Clients can access and act on their own data

`employee` — GC Employees have essential access to review and add insights to clients they are granted access to.

`user` — Registered Users are unassociated with any GC Role or Client and have minimal access.

### Authentication and Authorization Flow

::: mermaid
sequenceDiagram
    participant Client
    participant Auth
    participant API
    participant Permissions
    participant Resource
    Auth-->>Client: Send X-CSRF-TOKEN
    Client->>Auth: Grant Auth: Client Credentials
    loop User
        Auth->>Auth: generate JWT
    end
    Auth-->>Client: Access Token + Refresh Token
    Client->>API: Request Resource + Access Token
    loop Permissions
        API-->>Permissions: Verify Permissions
        Permissions-->>API: Permission Granted
    end
    API->>Resource: Fetch Requested Resource
    Resource-->>Client: Protected Resource

    Note over Client,Resource: After Time: Access Token Expires
    API-->>Client: Access Token Expired
    Client->>Auth: Grant Auth: Refresh Token
    loop User
        Auth->>Auth: generate JWT
    end
    Auth-->>Client: New Access Token + New Refresh Token

    Client->>API: Request Resource + New Access Token
    loop Permissions
        API-->>Permissions: Verify Permissions
        Permissions-->>API: Permission Granted
    end
    API->>Resource: Fetch Requested Resource
    Resource-->>Client: Protected Resource
    Client->>API: Request Resource + BAD Access Token
    Note over Client,Resource: If Access Token Abuse: Revoked Tokens
    API-->>Client: Invalid Token Error
    loop Permissions
        API-->>Permissions: Revoke Tokens
        Permissions-->>API: Tokens Revoked
    end
    API-->>Client: Access Revoked
    Client->>Auth: Grant Auth:<br/>Refresh Token<br/>+ Client Credentials
    loop User
        Auth->>Auth: generate JWT
    end
    Auth-->>Client: Access Token + Refresh Token
:::

----

## Testing Tools

### GitLeaks

    gitleaks detect --verbose --config=./gitleaks.toml

#### References

- [GitLeaks Repository](https://github.com/zricethezav/gitleaks)
- [GitLeaks Allow List for Inline Cases of False Positive Secrets Leak](https://github.com/zricethezav/gitleaks/issues/579)
- [GitLeaks Custom Config .toml File](https://github.com/zricethezav/gitleaks/issues/787)
