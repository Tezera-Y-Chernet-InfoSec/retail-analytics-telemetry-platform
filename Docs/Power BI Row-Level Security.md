# Power BI Row-Level Security (RLS)

## 1. Overview

Row-Level Security (RLS) restricts the rows of data users can access in a Power BI semantic model. It helps protect sensitive business data by ensuring that users see only the information authorized for them.

This document covers two RLS approaches:

- **Static RLS:** Restricts access using a fixed condition, such as `Region = "West"`.
- **Dynamic RLS:** Determines access based on the signed-in user's identity and a user-to-region access table.

## 2. Business Scenario

A retail company operates stores across the West, East, and North regions. Regional managers should see sales data only for their authorized regions.

| Region | Example store  | Authorized access |
| ------ | -------------- | ----------------- |
| West   | Seattle Store  | West managers     |
| East   | New York Store | East managers     |
| North  | Chicago Store  | North managers    |

**Analogy:** RLS works like a security guard. Static RLS gives the guard a fixed instruction to admit only West-region stores. Dynamic RLS gives the guard an access list identifying which regions each user may enter.

## 3. Static RLS Implementation

Static RLS applies the same fixed filter to every user assigned to a particular role.

### Steps

1. In Power BI Desktop, select **Modeling → Manage roles**.
2. Create a role named `WestManager`.
3. Select the `DimStores` table.
4. Apply the following DAX filter:

```dax
[region] = "West"
```

5. Save the role and validate it using **Modeling → View as**.
6. After publishing, assign the appropriate users or security groups to the role in Power BI Service.

### Expected result

Users assigned to `WestManager` can access West-region store rows, while East and North rows are filtered out.

**Use case:** Suitable when a fixed group of users needs the same regional access.

## 4. Dynamic RLS Implementation

Dynamic RLS determines the permitted data based on the current user's identity. A single role can support users who have different regional permissions.

### Step 1: Create the access-control table

Create a table named `UserRegionAccess`.

| UserName                 | Region |
| ------------------------ | ------ |
| manager.west@example.com | West   |
| manager.east@example.com | East   |
| tezerac@gmail.com        | West   |

Each row defines a user's authorized region. A user can have multiple rows if they are permitted to access multiple regions.

### Step 2: Create the dynamic RLS role

In **Modeling → Manage roles**, create a role such as `RegionalAccess`.

Apply this DAX expression as a table filter on `DimStores`:

```dax
VAR CurrentUser = USERPRINCIPALNAME()
RETURN
    COUNTROWS(
        FILTER(
            UserRegionAccess,
            UserRegionAccess[UserName] = CurrentUser
                && UserRegionAccess[Region] = DimStores[region]
        )
    ) > 0
```

**How it works:**

- `USERPRINCIPALNAME()` retrieves the signed-in user's identity.
- `FILTER()` searches for access records matching that identity and the current store's region.
- `COUNTROWS() > 0` allows the store row if a matching permission exists.
- If no matching permission exists, the store row is excluded.

**Important:** The user identity in `UserRegionAccess[UserName]` must match the value returned by `USERPRINCIPALNAME()`. Confirm that `DimStores[region]` matches the actual table and column names in your model.

### Step 3: Validate and assign access

1. Test the `RegionalAccess` role using **View as** in Power BI Desktop.
2. Verify the behavior with representative user identities.
3. Publish the semantic model.
4. Assign authorized users or groups to the dynamic role in Power BI Service.
5. Confirm that each user sees only their permitted regional data.

## 5. How Security Filters Affect Sales Data

In a typical star schema, `DimStores` is related to `FactSales` using `StoreID`.

```text
DimStores
    |
    | StoreID relationship
    v
FactSales
```

When the security filter propagates through the relationship, users see sales only for the stores permitted by their role.

For example, if West-region stores have sales of $10,000 and $8,000, the West manager's expected sales total is:

```text
$10,000 + $8,000 = $18,000
```

Confirm that the relationship is active and that the security filter propagates as expected.

## 6. Static RLS vs. Dynamic RLS

| Feature                               | Static RLS                               | Dynamic RLS                                   |
| ------------------------------------- | ---------------------------------------- | --------------------------------------------- |
| Access rule                           | Fixed condition                          | User-based permission lookup                  |
| Example                               | `[region] = "West"`                      | `USERPRINCIPALNAME()` with `UserRegionAccess` |
| Different regions for different users | Usually requires separate roles or rules | Supported through the access table            |
| Maintenance                           | More manual as requirements grow         | Centralized in the access table               |
| Best suited for                       | Small, fixed access groups               | Multiple users with different permissions     |

## 7. Important Security Considerations

- RLS filters accessible data rows; it does not hide report pages.
- Report filters and slicers are not substitutes for RLS.
- Users must be assigned to the appropriate role in Power BI Service.
- Workspace Admins, Members, and Contributors generally are not restricted by RLS in the same way as Viewers.
- Validate relationships and test access using representative user identities.
- In dynamic RLS, users without a matching access record should receive no regional rows under this rule.
- Avoid granting broad access unintentionally through incorrect mapping records or additional roles.
