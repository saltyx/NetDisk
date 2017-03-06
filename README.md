# NetDisk API Version 0.1

## 简介
此项目为毕设的个人网盘的API设计与实现部分，用于与客户端交互使用

## Models

### USER
|#|column|type|
|:---:|:---:|:---:|
|1|name|string|
|2|email|string|
|3|password|string|
|4|is_admin|boolean|
|5|last_login_ip|string|
|6|last_login_time|string|
|7|last_login_device|string|
|8|total_storage|integer|
|9|used_storage|integer|
|10|password_digest|string|
|11|token|string|

### USER_FILES
|#|column|type|
|:---:|:---:|:---:|
|1|user_id|integer|
|2|file_name|string|
|3|file_size|integer|
|4|file_path|string|
|5|from_folder|integer|
|6|is_folder|boolean|
|7|is_shared|boolean|
|8|is_encrypted|boolean|
|9|download_link|string|
|10|download_times|integer|

## 进度
- [x] **Login API**

- [x] **UploadFile API**

- [x] **UploadBigFile API** [_**not tested**_]

- [x] **CreateFolder API** 

- [x] **DeleteFolder API**

- [x] **UpdateFolder API**

- [x] **GetFilesByFolder API**

- [x] **ShareFile API**

- [x] **CancelSharing API**

- [x] **CopyFile API**

- [x] **MoveFile API**

- [x] **DeleteFile API**

- [x] **UpdateFile API**

## TODOs

- [ ] **EncryptFile API**

- [ ] **EncryptFolder API**

## Usage

- **Login API**

|param|return|
|:---:|:----:|
|name|token|
|password|

> EXAMPLE Method _POST_
>> http://base-url/v1/login/
>>> ```{"user": {"name":"test","password": "123"}} ```

- **UploadFile API**

|param|return|
|:---:|:----:|
|file_size|STATUS|
|from_folder|file_id|
|token||
|file||

> EXAMPLE Method _POST_
>> http://base-url/v1/file/upload/1
>>> _header_: Authorization Token token=token-you-got-when-logging-in <br> 
>>> file: binary-file <br>
>>> filesize: file-size 






