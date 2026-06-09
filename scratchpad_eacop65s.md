# Task: Extract profile and user endpoints from Postman documentation

## Plan
1. Identify all profile/user related endpoints. (In progress: checking sidebar top for patient/nurse profile endpoints)
2. Extract details (Path, Method, Request Body, Response Schema) for each.
3. Update scratchpad and report.

## Findings
## Findings
*Status: Attempting to scroll sidebar to the top using smaller delta.*

### 1. GET patient get users
- **Method:** GET
- **Path:** `http://localhost:3000/admin/users`
- **Response Schema (403 Forbidden):**
  ```json
  {
    "message": "Not authorized"
  }
  ```

### 2. DELETE pateint delete user
- **Method:** DELETE
- **Path:** `http://localhost:3000/admin/users/:id`
- **Response Schema (403 Forbidden):**
  ```json
  {
    "message": "Not authorized"
  }
  ```

### 3. PUT update profile
- **Method:** PUT
- **Path:** `http://localhost:3000/profile`
- **Request Body:**
  ```json
  {
    "firstName": "Kareem",
    "lastName": "gomaa",
    "phone": "0111233445566789"
  }
  ```
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "Profile updated",
    "data": {
      "user": {
        "_id": "69de14950a19bb2a9cfffa9f",
        "firstName": "Kareem",
        "lastName": "جمعه",
        "email": "gomaak151@gmail.com",
        "phone": "fd28f004a76f934f31707e1b042f781d:255b3f625a9e6130bf07106c09357f05",
        "role": 2,
        "gender": 0,
        "provider": 0,
        "address": "jjjjkk",
        "nurseDocument": null,
        "oldPassword": [],
        "coverProfilePictures": [],
        "createdAt": "2026-04-14T10:19:01.085Z",
        "updatedAt": "2026-04-14T14:05:42.064Z",
        "__v": 2,
        "confirmEmail": "2026-04-14T10:19:33.608Z",
        "username": "Kareem جمعه",
        "id": "69de14950a19bb2a9cfffa9f"
      }
    }
  }
  ```

### 4. PUT update password
- **Method:** PUT
- **Path:** `http://localhost:3000/profile/password`
- **Request Body:**
  ```json
  {
    "oldPassword": "Patient@123",
    "password": "Patient@123",
    "confirmPassword": "Patient@123"
  }
  ```
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "Password updated"
  }
  ```

### 5. PATCH update profile-picture
- **Method:** PATCH
- **Path:** `http://localhost:3000/user/profile-image`
- **Request Body:** (multipart/form-data with image file)
- **Response Schema:** (No response body)

### 6. GET share-profile
- **Method:** GET
- **Path:** `http://localhost:3000/user/:id/share-profile`
- **Response Schema (200 OK):**
  ```json
  {
    "message": "Profile",
    "account": {
      "nurseDocument": null,
      "profilePicture": {
        "secure_url": "https://res.cloudinary.com/demo/image/upload/sample.jpg",
        "public_id": "demo/patient-ahmed-profile"
      },
      "_id": "69ee6a1f454e0f5ddc9b1cec",
      "email": "ahmed.elsayed@hadana-demo.com",
      "__v": 23,
      "address": "Building 24, Abbas El Akkad, Nasr City, Cairo",
      "confirmEmail": "2026-04-26T19:44:01.199Z",
      "coverProfilePictures": [],
      "createdAt": "2026-04-26T19:40:15.645Z",
      "gender": 0,
      "lastSeenAt": "2026-05-01T19:26:09.141Z",
      "oldPassword": [],
      "phone": "01014567890",
      "provider": 0,
      "role": 2,
      "updatedAt": "2026-05-01T19:26:09.141Z",
      "firstName": "أحمد",
      "lastName": "السيد",
      "username": "أحمد السيد",
      "id": "69ee6a1f454e0f5ddc9b1cec"
    }
  }
  ```

### 7. GET hospital profile
- **Method:** GET
- **Path:** `http://localhost:3000/hospital-account/profile`
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "hospital account profile",
    "data": {
      "profile": {
        "hospitalId": "69dcd96360a861179a9735f8",
        "hospitalName": "Hospital Test Account",
        "address": "University Street, Beni Suef",
        "city": "Beni Suef",
        "email": "hospitaltest@demo.com",
        "phone": "01099999999",
        "password": "********",
        "placesShortcut": {
          "route": "/hospital-account/profile/places",
          "label": "تعديل الأماكن المتاحة"
        }
      }
    }
  }
  ```

### 8. GET hospital places
- **Method:** GET
- **Path:** `http://localhost:3000/hospital-account/profile/places`
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "hospital account places",
    "data": {
      "places": {
        "hospitalId": "69dcd96360a861179a9735f8",
        "placeGroups": [
          {
            "key": "childcare",
            "title": "حضانات الأطفال",
            "services": [
              {
                "_id": "69dcd96460a861179a973604",
                "name": "?????? ?????",
                "type": "حضانات أطفال",
                "capacity": 5
              },
              {
                "_id": "69dcd96460a861179a973607",
                "name": "??????? ????? ??????? (NICU)",
                "type": "حضانات أطفال",
                "capacity": 4
              },
              {
                "_id": "69dcfac423e2b216f4e18a65",
                "name": "Nursery Room 1",
                "type": "حضانات أطفال",
                "capacity": 10
              },
              {
                "_id": "69de4f50cb87c194bb7d1f28",
                "name": "Nursery Room 1",
                "type": "حضانات أطفال",
                "capacity": 10
              },
              {
                "_id": "69de532637ccb7f99edb6abb",
                "name": "Nursery Room 1",
                "type": "حضانات أطفال",
                "capacity": 10
              }
            ]
          },
          {
            "key": "healthcare",
            "title": "عناية مركزة",
            "services": [
              {
                "_id": "69dcd96460a861179a9735fe",
                "name": "????? ?:?:? (CCU)",
                "type": "عناية مركزة",
                "capacity": 3
              },
              {
                "_id": "69dcd96460a861179a9735fb",
                "name": "????? ????? ?????? (ICU)",
                "type": "عناية مركزة",
                "capacity": 5
              },
              {
                "_id": "69dcd96460a861179a973601",
                "name": "????? ?????? (PICU)",
                "type": "عناية مركزة",
                "capacity": 2
              },
              {
                "_id": "69de33b2794149b51e060d9c",
                "name": "CCU Care Room",
                "type": "عناية مركزة",
                "capacity": 3
              },
              {
                "_id": "69dcfbd123e2b216f4e18a6f",
                "name": "General Clinic Room",
                "type": "عناية مركزة",
                "capacity": 8
              }
            ]
          }
        ]
      }
    }
  }
  ```

### 9. PATCH update hospital profile
- **Method:** PATCH
- **Path:** `http://localhost:3000/hospital-account/profile`
- **Request Body:**
  ```json
  {
    "hospitalName": "New Hospital Name",
    "address": "Nasr City",
    "city": "Cairo",
    "email": "newhospital@gmail.com",
    "phone": "01098765432"
  }
  ```
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "hospital account profile updated",
    "data": {
      "profile": {
        "hospitalId": "69dcd96360a861179a9735f8",
        "hospitalName": "New Hospital Name",
        "address": "Nasr City",
        "city": "Cairo",
        "email": "newhospital@gmail.com",
        "phone": "01098765432",
        "password": "********",
        "placesShortcut": {
          "route": "/hospital-account/profile/places",
          "label": "تعديل الأماكن المتاحة"
        }
      }
    }
  }
  ```

### 10. PATCH update hospital password
- **Method:** PATCH
- **Path:** `http://localhost:3000/hospital-account/profile/password`
- **Request Body:**
  ```json
  {
    "currentPassword": "Hospital1!",
    "password": "NewPassword123$",
    "confirmPassword": "NewPassword123$"
  }
  ```
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "hospital account password updated successfully"
  }
  ```

### 11. GET admin get users
- **Method:** GET
- **Path:** `http://localhost:3000/admin/users`
- **Response Schema (200 OK):**   ```json
  {
    "status": 200,
    "message": "Done",
    "data": {
      "users": {
        "summary": [
          {
            "role": 1,
            "label": "hospitals",
            "total": 1,
            "activeNow": 0
          },
          {
            "role": 2,
            "label": "patients",
            "total": 6,
            "activeNow": 0
          },
          {
            "role": 3,
            "label": "nurses",
            "total": 1,
            "activeNow": 0
          }
        ],
        "users": [
          {
            "_id": "69de33b1794149b51e060d95",
            "firstName": "?????",
            "lastName": "????",
            "email": "patienttest@demo.com",
            "role": 2,
            "isConfirmed": true,
            "lastSeenAt": null,
            "isActiveNow": false,
            "createdAt": "2026-04-14T12:31:45.914Z"
          },
          {
            "_id": "69de1e414098485272b81d21a",
            "firstName": "فريد",
            "lastName": "وليد",
            "email": "f14074372@gmail.com",
            "role": 2,
            "isConfirmed": true,
            "lastSeenAt": null,
            "isActiveNow": false,
            "createdAt": "2026-04-14T11:00:49.114Z"
          }
        ]
      }
    }
  }
  ```

### 12. GET admin get users by role
- **Method:** GET
- **Path:** `http://localhost:3000/admin/users`
- **Query Params:**
  - `role`: `1` (example for hospitals)
- **Response Schema (200 OK):**   ```json
  {
    "status": 200,
    "message": "Done",
    "data": {
      "users": {
        "summary": [
          {
            "role": 1,
            "label": "hospitals",
            "total": 1,
            "activeNow": 0
          },
          {
            "role": 2,
            "label": "patients",
            "total": 6,
            "activeNow": 0
          },
          {
            "role": 3,
            "label": "nurses",
            "total": 1,
            "activeNow": 0
          }
        ],
        "users": [
          {
            "_id": "69dcd96360a861179a9735f5",
            "firstName": "Hospital",
            "lastName": "Tester",
            "email": "newhospital@gmail.com",
            "role": 1,
            "isConfirmed": true,
            "lastSeenAt": null,
            "isActiveNow": false,
            "createdAt": "2026-04-13T11:54:11.307Z"
          }
        ]
      }
    }
  }
  ```

### 13. POST admin adding patient
- **Method:** POST
- **Path:** `http://localhost:3000/admin/user`
- **Request Body:**
  ```json
  {
    "username": "محمد احمد",
    "email": "patient1@example.com",
    "password": "Admin@1234",
    "phone": "01012345678",
    "address": "Cairo, Nasr City, Street 10",
    "role": 2,
    "gender": 0
  }
  ```
- **Response Schema (201 Created):**
  ```json
  {
    "status": 201,
    "message": "User added",
    "data": {
      "user": {
        "_id": "69dfce9cd886ad7cf8168edb",
        "username": "محمد احمد",
        "email": "patient1@example.com",
        "role": 2,
        "hospitalId": null
      }
    }
  }
  ```

### 14. POST admin adding nurse
- **Method:** POST
- **Path:** `http://localhost:3000/admin/user`
- **Request Body:**
  ```json
  {
    "username": "سارة علي",
    "email": "nurse1@example.com",
    "password": "Admin@1234",
    "phone": "01012345678",
    "address": "Alexandria, Smouha, Street 3",
    "role": 3,
    "gender": 1
  }
  ```
- **Response Schema (201 Created):**
  ```json
  {
    "status": 201,
    "message": "User added",
    "data": {
      "user": {
        "_id": "69dfd5b051e7984f99e796d2",
        "username": "سارة علي",
        "email": "nurse1@example.com",
        "role": 3,
        "hospitalId": null
      }
    }
  }
  ```

### 15. POST admin adding hospital
- **Method:** POST
- **Path:** `http://localhost:3000/admin/hospital`
- **Request Body:**
  ```json
  {
    "name": "مستشفى السلام",
    "location": {
      "city": "Giza",
      "address": "Dokki, Street 5"
    },
    "logo": "https://example.com/hospital-logo.png",
    "username": "مستشفى السلام",
    "email": "hospitaluser1@example.com",
    "password": "Admin@1234",
    "phone": "01012345678",
    "address": "Giza, Dokki, Street 5",
    "gender": 0
  }
  ```
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "Hospital added",
    "data": {
      "hospital": {
        "name": "مستشفى السلام",
        "location": {
          "city": "Giza",
          "address": "Dokki, Street 5"
        },
        "_id": "69dfd49351e7984f99e796b2",
        "createdAt": "2026-04-15T18:10:27.612Z",
        "updatedAt": "2026-04-15T18:10:27.612Z",
        "__v": 0,
        "id": "69dfd49351e7984f99e796b2",
        "accountId": "69dfd49351e7984f99e796b6"
      },
      "partner": {
        "name": "مستشفى السلام",
        "logo": "https://example.com/hospital-logo.png",
        "type": "hospital",
        "_id": "69dfd49351e7984f99e796b4",
        "createdAt": "2026-04-15T18:10:27.692Z",
        "updatedAt": "2026-04-15T18:10:27.692Z",
        "__v": 0
      },
      "user": {
        "_id": "69dfd49351e7984f99e796b6",
        "username": "مستشفى السلام",
        "email": "hospitaluser1@example.com",
        "role": 1
      }
    }
  }
  ```

### 16. DELETE admin delete patient
- **Method:** DELETE
- **Path:** `http://localhost:3000/admin/user/:id` (Example: `http://localhost:3000/admin/user/69dfd53a51e7984f99e796c3`)
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "User deleted"
  }
  ```

### 17. DELETE admin delete nurse
- **Method:** DELETE
- **Path:** `http://localhost:3000/admin/user/:id` (Example: `http://localhost:3000/admin/user/69dfd4432b3f14cae0e909e0`)
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "User deleted"
  }
  ```

### 18. DELETE admin remove hospital
- **Method:** DELETE
- **Path:** `http://localhost:3000/admin/hospital/:id` (Example: `http://localhost:3000/admin/hospital/69dfd49351e7984f99e796b6`)
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "Hospital deleted"
  }
  ```

### 19. PATCH admin update user
- **Method:** PATCH
- **Path:** `http://localhost:3000/admin/user/:id` (Example: `http://localhost:3000/admin/user/69dced592633c40262873772`)
- **Request Body:**
  ```json
  {
    "phone": "01111111111",
    "address": "New Cairo"
  }
  ```
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "User updated",
    "data": {
      "user": {
        "_id": "69dced592633c40262873772",
        "username": "كريم جمعة",
        "email": "test@gmail.com",
        "role": 2,
        "address": "New Cairo"
      }
    }
  }
  ```

### 20. PATCH admin update nurse
- **Method:** PATCH
- **Path:** `http://localhost:3000/admin/user/:id` (Example: `http://localhost:3000/admin/user/69dfd5b051e7984f99e796d2`)
- **Request Body:**
  ```json
  {
    "address": "Cairo, Nasr City, Street 12"
  }
  ```
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "User updated",
    "data": {
      "user": {
        "_id": "69dfd5b051e7984f99e796d2",
        "username": "سارة علي",
        "email": "nurse1@example.com",
        "role": 3,
        "address": "Cairo, Nasr City, Street 12"
      }
    }
  }
  ```

### 21. PATCH admin update hospital
- **Method:** PATCH
- **Path:** `http://localhost:3000/admin/hospital/:id` (Example: `http://localhost:3000/admin/hospital/69dfdf988d398ff4b6086a66`)
- **Request Body:**
  ```json
  {
    "name": "مستشفى محدثة",
    "location": {
      "city": "Giza",
      "address": "Dokki, Street 20"
    },
    "logo": "https://example.com/new-logo.png"
  }
  ```
- **Response Schema (200 OK):**
  ```json
  {
    "status": 200,
    "message": "Hospital updated",
    "data": {
      "hospital": {
        "location": {
          "city": "Giza",
          "address": "Dokki, Street 20"
        },
        "_id": "69dfdf988d398ff4b6086a66",
        "name": "مستشفى محدثة",
        "__v": 1,
        "updatedAt": "2026-04-15T18:58:09.043Z",
        "id": "69dfdf988d398ff4b6086a66"
      },
      "partner": null,
      "user": null
    }
  }
  ```
