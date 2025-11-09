1. Current project state
The registration form lives in `src/main/webapp/jsp/FillInformation.jsp`. The page renders the common header, shows the specification-required table `tblInputInformation`, and exposes `btnRegister` as the submit control. Validation feedback is shown through the shared `${errors}` attribute and individual field values are preserved with `${formData}`.

All HTTP traffic now flows through `com.qlst.servlet.RegisterServlet`. `GET /register` simply forwards to `FillInformation.jsp`. `POST /register` handles UTF-8 decoding, trims the submitted data, validates required fields, checks username/email uniqueness through `UserDAO`, hashes the password via `PasswordUtil`, and persists the request with `MemberDAO`. When everything succeeds, the servlet forwards to `/jsp/DoSaveMember.jsp` so the user immediately sees the confirmation details before navigating to `/login`.

`DoSaveMember.jsp` renders the shared header, displays a concise "account created" notification, and reuses a `${member}` request attribute to echo the username, email, address, and phone that were stored. It also exposes a clear call-to-action (button or link) that points to `/login?registered=true`, making the success-to-login flow explicit without hiding the confirmation page.

`MemberDAO.saveInformation(Member)` keeps using a single JDBC connection (inherited from `DAO`) to wrap inserts into `tblUsers` and `tblCustomers` in one transaction. The `Member` entity holds id, name (used as username), password, email, address, and phone so it mirrors the UI contract. Other screens (login, statistics, etc.) already link to `/register`, ensuring a single entry point regardless of navigation path.

2. Target derived from the specification
- UI must capture the six data points (name, password, email, address, phone) in the table layout required by the document, keep HTML `required` where relevant, and re-display previously submitted values on errors.
- Form submissions must hit `/register`, not a JSP scriptlet, so that validation, hashing, and persistence all live in servlet/DAO layers.
- `MemberDAO` remains the transactional bridge that writes both the user account row (role `CUSTOMER`) and the associated customer profile.
- After a successful POST, the servlet forwards to `DoSaveMember.jsp`, which shows the success message plus the sanitized customer information before offering a login link.
- `Member`/`Customer` classes mirror the same field list that the form collects; optional values (address/phone) may be `null` when not provided.
- Navigation items across JSPs should highlight `currentPage == 'fillInformation'` but always link to `/register` for consistency.

3. Detailed implementation steps
Step 1: FillInformation.jsp
- Keep the view-only responsibilities in the JSP: branding header, table layout, `${errors}` list, and `${formData}` binding.
- Update the `<form>` tag to `action="${ctx}/register"` and use `method="post"` with `autocomplete="off"` as before.

Step 2: DoSaveMember.jsp
- Display a success notification (e.g., inside `alert-success`) confirming that the account was created and persisted.
- Read the `${member}` attribute (or similarly named bean) to show the username, email, address, and phone exactly as saved; avoid re-querying the database.
- Provide a primary action to continue to `/login?registered=true` and, optionally, a secondary action to return to the home page.

Step 3: RegisterServlet
- Create `com.qlst.servlet.RegisterServlet` extending `HttpServlet`.
- `doGet` forwards to `/jsp/FillInformation.jsp`.
- `doPost` sets UTF-8 encoding, builds a `Member` instance for form echoing, performs field validations (empty fields, password length, email present), and queries `UserDAO.findByUsername` / `.findByEmail` to guard uniqueness.
- When validation fails, place `errors` and `formData` on the request scope and forward to the JSP; when it succeeds, hash the password and delegate to `MemberDAO.saveInformation`, handling SQL errors with logging plus user-friendly feedback before forwarding to `DoSaveMember.jsp`.

Step 4: MemberDAO
- Reuse the existing transactional pattern (`con.setAutoCommit(false)`), insert into `tblUsers`, capture the generated key, and call `CustomerDAO.save`.
- Ensure helper methods (such as `insertUser` and `toCustomer`) stay private and lean, and remember to restore the original auto-commit flag.

Step 5: Member entity
- Keep the `String`-typed fields (`id`, `name`, `password`, `email`, `address`, `phone`) and expose the necessary getters/setters so JSP EL can access them directly.

Step 6: Customer entity
- Continue extending `Member` (if needed) and append registration-specific metadata like `userAccountId` and `joinedAt`.

Step 7: Web layer wiring
- Register the servlet inside `src/main/webapp/WEB-INF/web.xml` with a `<url-pattern>/register</url-pattern>`.
- Ensure `/jsp/DoSaveMember.jsp` is part of the deployable resources and that `RegisterServlet` forwards to it only on success, keeping navigation links (`login.jsp`, `MainManagement.jsp`, statistics/customer views, etc.) pointed at `/register`.
- Keep the `currentPage` flag as `fillInformation` for menu highlighting.

Step 8: Database scripts
- No new tables are required if `tblUsers` and `tblCustomers` already exist. When introducing a dedicated `members` table, extend the provisioning scripts (`script/create_tables.py`) and update `MemberDAO` accordingly.

Step 9: Testing
- Cover happy- and sad-path flows: POST empty fields, duplicate usernames/emails, success forward to `DoSaveMember.jsp`, and CTA navigation to `/login`.
- Regression-test login using the freshly created account to confirm credentials were hashed properly and relationships were stored in both tables.

4. Completion checklist
- `FillInformation.jsp` renders the spec-compliant form and posts to `/register`.
- `DoSaveMember.jsp` displays the confirmation message plus the stored customer information and links to `/login`.
- `RegisterServlet` performs validation, hashing, uniqueness checks, and persistence before forwarding to the success page.
- `MemberDAO` and entities stay aligned with the UI contract.
- Every navigation link points to `/register`; no JSP performs business logic for registration.
- Manual or automated tests confirm both the registration and subsequent login flows.
