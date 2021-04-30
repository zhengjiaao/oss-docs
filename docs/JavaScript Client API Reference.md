# JavaScript Client API Reference 

[toc]

## Download from NPM
```batch
npm install --save oss-js-client
```

## Initialize OSS Client object.

## OSS

```js
var OSS = require('oss')

var ossClient = new OSS.Client({
    endPoint: '127.0.0.1',
    port: 9000,
    useSSL: true,
    accessKey: 'username',
    secretKey: 'password'
});
```

## AWS S3

```js
var OSS = require('oss')

var s3Client = new OSS.Client({
    endPoint:  's3.amazonaws.com',
    accessKey: 'YOUR-ACCESSKEYID',
    secretKey: 'YOUR-SECRETACCESSKEY'
})
```

| Bucket operations       | Object operations        | Presigned operations  | Bucket Policy & Notification operations |
| :---------------------- | :----------------------- | :-------------------- | :-------------------------------------- |
| `makeBucket`            | `getObject`              | `presignedUrl`        | `getBucketNotification`                 |
| `listBuckets`           | `getPartialObject`       | `presignedGetObject`  | `setBucketNotification`                 |
| `bucketExists`          | `fGetObject`             | `presignedPutObject`  | `removeAllBucketNotification`           |
| `removeBucket`          | `putObject`              | `presignedPostPolicy` | `getBucketPolicy`                       |
| `listObjects`           | `fPutObject`             |                       | `setBucketPolicy`                       |
| `listObjectsV2`         | `copyObject`             |                       | `listenBucketNotification`              |
| `listIncompleteUploads` | `statObject`             |                       |                                         |
| `getBucketVersioning`   | `removeObject`           |                       |                                         |
| `setBucketVersioning`   | `removeObjects`          |                       |                                         |
|                         | `removeIncompleteUpload` |                       |                                         |

## 1. Constructor

### new OSS.Client ({endPoint, port, useSSL, accessKey, secretKey, region, transport, sessionToken, partSize})

|                                                              |
| :----------------------------------------------------------- |
| `new OSS.Client ({endPoint, port, useSSL, accessKey, secretKey, region, transport, sessionToken, partSize})` |
| Initializes a new client object.                             |

**Parameters**

| Param          | Type     | Description                                                  |
| :------------- | :------- | :----------------------------------------------------------- |
| `endPoint`     | *string* | endPoint is a host name or an IP address.                    |
| `port`         | *number* | TCP/IP port number. This input is optional. Default value set to 80 for HTTP and 443 for HTTPs. |
| `useSSL`       | *bool*   | If set to true, https is used instead of http. Default is true. |
| `accessKey`    | *string* | accessKey is like user-id that uniquely identifies your account. |
| `secretKey`    | *string* | secretKey is the password to your account.                   |
| `region`       | *string* | Set this value to override region cache. (Optional)          |
| `transport`    | *string* | Set this value to pass in a custom transport. (Optional)     |
| `sessionToken` | *string* | Set this value to provide x-amz-security-token (AWS S3 specific). (Optional) |
| `partSize`     | *number* | Set this value to override default part size of 64MB for multipart uploads. (Optional) |
| `pathStyle`    | *bool*   | Set this value to override default access behavior (path) for non AWS endpoints. Default is true. (Optional) |

**Example**

## Create client for OSS

```js
var OSS = require('oss')

var ossClient = new OSS.Client({
    endPoint: '127.0.0.1',
    port: 9000,
    useSSL: true,
    accessKey: 'username',
    secretKey: 'password'
});
```

## Create client for AWS S3

```js
var OSS = require('oss')

var s3Client = new OSS.Client({
    endPoint:  's3.amazonaws.com',
    accessKey: 'YOUR-ACCESSKEYID',
    secretKey: 'YOUR-SECRETACCESSKEY'
})
```

## Ali OSS

```js
var OSS = require('oss')

var s3Client = new OSS.Client({
    endPoint:  'oss-cn-hangzhou.aliyuncs.com',
    accessKey: 'YOUR-ACCESSKEYID',
    secretKey: 'YOUR-SECRETACCESSKEY',
    bucket: 'YOUR-BUCKET',
    pathStyle: false,
    region: 'oss-cn-hangzhou'
})
```



## 2. Bucket operations



### makeBucket(bucketName, region[, makeOpts , callback])

Creates a new bucket.

**Parameters**

| Param           | Type       | Description                                                  |
| :-------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`    | *string*   | Name of the bucket.                                          |
| `region`        | *string*   | Region where the bucket is created. This parameter is optional. Default value is us-east-1. |
| `makeOpts`      | *object*   | Options to create a bucket. e.g `{ObjectLocking:true}` (Optional) |
| `callback(err)` | *function* | Callback function with `err` as the error argument. `err` is null if the bucket is successfully created. If no callback is passed, a `Promise` is returned. |

**Example**

```js
ossClient.makeBucket('mybucket', 'us-east-1', function(err) {
  if (err) return console.log('Error creating bucket.', err)
  console.log('Bucket created successfully in "us-east-1".')
})
```

**Example 1**
Create a bucket with object locking enabled.

```js
ossClient.makeBucket('mybucket', 'us-east-1', { ObjectLocking:true }, function(err) {
  if (err) return console.log('Error creating bucket with object lock.', err)
  console.log('Bucket created successfully in "us-east-1" and enabled object lock')
})
```



### listBuckets([callback])

Lists all buckets.

**Parameters**

| Param                         | Type       | Description                                                  |
| :---------------------------- | :--------- | :----------------------------------------------------------- |
| `callback(err, bucketStream)` | *function* | Callback function with error as the first argument. `bucketStream` is the stream emitting bucket information. If no callback is passed, a `Promise` is returned. |

bucketStream emits Object with the format:-

| Param                 | Type     | Description                   |
| :-------------------- | :------- | :---------------------------- |
| `bucket.name`         | *string* | bucket name                   |
| `bucket.creationDate` | *Date*   | date when bucket was created. |

**Example**

```js
ossClient.listBuckets(function(err, buckets) {
  if (err) return console.log(err)
  console.log('buckets :', buckets)
})
```



#### bucketExists(bucketName[, callback])

Checks if a bucket exists.

**Parameters**

| Param                   | Type       | Description                                                  |
| :---------------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`            | *string*   | Name of the bucket.                                          |
| `callback(err, exists)` | *function* | `exists` is a boolean which indicates whether `bucketName` exists or not. `err` is set when an error occurs during the operation. If no callback is passed, a `Promise` is returned. |

**Example**

```js
ossClient.bucketExists('mybucket', function(err, exists) {
  if (err) {
    return console.log(err)
  }
  if (exists) {
    return console.log('Bucket exists.')
  }
})
```



### removeBucket(bucketName[, callback])

Removes a bucket.

**Parameters**

| Param           | Type       | Description                                                  |
| :-------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`    | *string*   | Name of the bucket.                                          |
| `callback(err)` | *function* | `err` is `null` if the bucket is removed successfully. If no callback is passed, a `Promise` is returned. |

**Example**

```js
ossClient.removeBucket('mybucket', function(err) {
  if (err) return console.log('unable to remove bucket.')
  console.log('Bucket removed successfully.')
})
```



### listObjects(bucketName, prefix, recursive [,listOpts])

Lists all objects in a bucket.

**Parameters**

| Param        | Type     | Description                                                  |
| :----------- | :------- | :----------------------------------------------------------- |
| `bucketName` | *string* | Name of the bucket.                                          |
| `prefix`     | *string* | The prefix of the objects that should be listed (optional, default `''`). |
| `recursive`  | *bool*   | `true` indicates recursive style listing and `false` indicates directory style listing delimited by '/'. (optional, default `false`). |
| `listOpts`   | *object* | query params to list object which can have `{IncludeVersion: _bool_ }` (optional) |

**Return Value**

| Param    | Type     | Description                                |
| :------- | :------- | :----------------------------------------- |
| `stream` | *Stream* | Stream emitting the objects in the bucket. |

The object is of the format:

| Param                | Type      | Description                    |
| :------------------- | :-------- | :----------------------------- |
| `obj.name`           | *string*  | name of the object.            |
| `obj.prefix`         | *string*  | name of the object prefix.     |
| `obj.size`           | *number*  | size of the object.            |
| `obj.etag`           | *string*  | etag of the object.            |
| `obj.versionId`      | *string*  | versionId of the object.       |
| `obj.isDeleteMarker` | *boolean* | true if it is a delete marker. |
| `obj.lastModified`   | *Date*    | modified time stamp.           |

**Example**

```js
var stream = ossClient.listObjects('mybucket','', true)
stream.on('data', function(obj) { console.log(obj) } )
stream.on('error', function(err) { console.log(err) } )
```

**Example1**
To get Object versions

```js
var stream = ossClient.listObjects('mybucket','', true, {IncludeVersion:true})
stream.on('data', function(obj) { console.log(obj) } )
stream.on('error', function(err) { console.log(err) } )
```



### listObjectsV2(bucketName, prefix, recursive, startAfter)

Lists all objects in a bucket using S3 listing objects V2 API

**Parameters**

| Param        | Type     | Description                                                  |
| :----------- | :------- | :----------------------------------------------------------- |
| `bucketName` | *string* | Name of the bucket.                                          |
| `prefix`     | *string* | The prefix of the objects that should be listed (optional, default `''`). |
| `recursive`  | *bool*   | `true` indicates recursive style listing and `false` indicates directory style listing delimited by '/'. (optional, default `false`). |
| `startAfter` | *string* | Specifies the object name to start after when listing objects in a bucket. (optional, default `''`). |

**Return Value**

| Param    | Type     | Description                                |
| :------- | :------- | :----------------------------------------- |
| `stream` | *Stream* | Stream emitting the objects in the bucket. |

The object is of the format:

| Param              | Type     | Description                |
| :----------------- | :------- | :------------------------- |
| `obj.name`         | *string* | name of the object.        |
| `obj.prefix`       | *string* | name of the object prefix. |
| `obj.size`         | *number* | size of the object.        |
| `obj.etag`         | *string* | etag of the object.        |
| `obj.lastModified` | *Date*   | modified time stamp.       |

**Example**

```js
var stream = ossClient.listObjectsV2('mybucket','', true,'')
stream.on('data', function(obj) { console.log(obj) } )
stream.on('error', function(err) { console.log(err) } )
```



### listObjectsV2WithMetadata(bucketName, prefix, recursive, startAfter)

Lists all objects and their metadata in a bucket using S3 listing objects V2 API

**Parameters**

| Param        | Type     | Description                                                  |
| :----------- | :------- | :----------------------------------------------------------- |
| `bucketName` | *string* | Name of the bucket.                                          |
| `prefix`     | *string* | The prefix of the objects that should be listed (optional, default `''`). |
| `recursive`  | *bool*   | `true` indicates recursive style listing and `false` indicates directory style listing delimited by '/'. (optional, default `false`). |
| `startAfter` | *string* | Specifies the object name to start after when listing objects in a bucket. (optional, default `''`). |

**Return Value**

| Param    | Type     | Description                                |
| :------- | :------- | :----------------------------------------- |
| `stream` | *Stream* | Stream emitting the objects in the bucket. |

The object is of the format:

| Param              | Type     | Description                |
| :----------------- | :------- | :------------------------- |
| `obj.name`         | *string* | name of the object.        |
| `obj.prefix`       | *string* | name of the object prefix. |
| `obj.size`         | *number* | size of the object.        |
| `obj.etag`         | *string* | etag of the object.        |
| `obj.lastModified` | *Date*   | modified time stamp.       |
| `obj.metadata`     | *object* | metadata of the object.    |

**Example**

```js
var stream = ossClient.extensions.listObjectsV2WithMetadata('mybucket','', true,'')
stream.on('data', function(obj) { console.log(obj) } )
stream.on('error', function(err) { console.log(err) } )
```



### listIncompleteUploads(bucketName, prefix, recursive)

Lists partially uploaded objects in a bucket.

**Parameters**

| Param        | Type     | Description                                                  |
| :----------- | :------- | :----------------------------------------------------------- |
| `bucketname` | *string* | Name of the bucket.                                          |
| `prefix`     | *string* | Prefix of the object names that are partially uploaded. (optional, default `''`) |
| `recursive`  | *bool*   | `true` indicates recursive style listing and `false` indicates directory style listing delimited by '/'. (optional, default `false`). |

**Return Value**

| Param    | Type     | Description                               |
| :------- | :------- | :---------------------------------------- |
| `stream` | *Stream* | Emits objects of the format listed below: |

| Param           | Type      | Description                            |
| :-------------- | :-------- | :------------------------------------- |
| `part.key`      | *string*  | name of the object.                    |
| `part.uploadId` | *string*  | upload ID of the object.               |
| `part.size`     | *Integer* | size of the partially uploaded object. |

**Example**

```js
var Stream = ossClient.listIncompleteUploads('mybucket', '', true)
Stream.on('data', function(obj) {
  console.log(obj)
})
Stream.on('end', function() {
  console.log('End')
})
Stream.on('error', function(err) {
  console.log(err)
})
```



### getBucketVersioning(bucketName)

Get Versioning state of a Bucket

**Parameters**

| Param                | Type       | Description                                                  |
| :------------------- | :--------- | :----------------------------------------------------------- |
| `bucketname`         | *string*   | Name of the bucket.                                          |
| `callback(err, res)` | *function* | Callback is called with `err` in case of error. `res` is the response object. If no callback is passed, a `Promise` is returned. |

**Example**

```js
ossClient.getBucketVersioning('bucketname', function (err,res){
  if (err) {
    return console.log(err)
  }
  console.log(res)
  console.log("Success")
})
```



### setBucketVersioning(bucketName, versioningConfig, callback)

Set Versioning state on a Bucket

**Parameters**

| Param              | Type       | Description                                        |
| :----------------- | :--------- | :------------------------------------------------- |
| `bucketname`       | *string*   | Name of the bucket.                                |
| `versioningConfig` | *object*   | Versioning Configuration e.g: `{Status:"Enabled"}` |
| `callback(err)`    | *function* | Callback is called with `err` in case of error.    |

**Example**

```js
var versioningConfig = {Status:"Enabled"}
ossClient.setBucketVersioning('bucketname',versioningConfig, function (err){
  if (err) {
    return console.log(err)
  }
  console.log("Success")
})
```



### setObjectLockConfig(bucketName, lockConfig [, callback])

Set Object lock config on a Bucket

**Parameters**

| Param           | Type       | Description                                                  |
| :-------------- | :--------- | :----------------------------------------------------------- |
| `bucketname`    | *string*   | Name of the bucket.                                          |
| `lockConfig`    | *object*   | Lock Configuration can be either `{}` to reset or object with all of the following key/value pairs: `{mode: ["COMPLIANCE"/'GOVERNANCE'], unit: ["Days"/"Years"], validity: <a-valid-number-for-unit>}` |
| `callback(err)` | *function* | Callback is called with `err` in case of error.              |

**Example 1**

```js
s3Client.setObjectLockConfig('my-bucketname', {mode:"COMPLIANCE", unit:'Days', validity:10 }, function (err){
    if (err) {
        return console.log(err)
    }
    console.log("Success")
})
```

**Example 2**
To reset/remove object lock config on a bucket.

```js
s3Client.setObjectLockConfig('my-bucketname', {}, function (err){
if (err) {
return console.log(err)
}
console.log("Success")
})
```



### getObjectLockConfig(bucketName [, callback])

Get Lock config on a Bucket

**Parameters**

| Param                       | Type       | Description                                                  |
| :-------------------------- | :--------- | :----------------------------------------------------------- |
| `bucketname`                | *string*   | Name of the bucket.                                          |
| `callback(err, lockConfig)` | *function* | Callback is called with `err` in case of error. else it is called with lock configuration |

__Example __
Get object lock configuration on a Bucket

```js
s3Client.getObjectLockConfig('my-bucketname', function (err, lockConfig){
    if (err) {
        return console.log(err)
    }
    console.log(lockConfig)
})
```

## 3. Object operations



### getObject(bucketName, objectName, getOpts[, callback])

Downloads an object as a stream.

**Parameters**

| Param                   | Type       | Description                                                  |
| :---------------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`            | *string*   | Name of the bucket.                                          |
| `objectName`            | *string*   | Name of the object.                                          |
| `getOpts`               | *object*   | Version of the object in the form `{versionId:"my-versionId"}`. Default is `{}`. (optional) |
| `callback(err, stream)` | *function* | Callback is called with `err` in case of error. `stream` is the object content stream. If no callback is passed, a `Promise` is returned. |

**Return Value**

| Param    | Type     | Description                         |
| :------- | :------- | :---------------------------------- |
| `stream` | *Stream* | Stream emitting the object content. |

**Example**

```js
var size = 0
ossClient.getObject('mybucket', 'photo.jpg', function(err, dataStream) {
  if (err) {
    return console.log(err)
  }
  dataStream.on('data', function(chunk) {
    size += chunk.length
  })
  dataStream.on('end', function() {
    console.log('End. Total size = ' + size)
  })
  dataStream.on('error', function(err) {
    console.log(err)
  })
})
```

**Example**

Get a specific object version.

```js
var size = 0
ossClient.getObject('mybucket', 'photo.jpg', {versionId:"my-versionId"}, function(err, dataStream) {
  if (err) {
    return console.log(err)
  }
  dataStream.on('data', function(chunk) {
    size += chunk.length
  })
  dataStream.on('end', function() {
    console.log('End. Total size = ' + size)
  })
  dataStream.on('error', function(err) {
    console.log(err)
  })
})
```



### getPartialObject(bucketName, objectName, offset, length, getOpts[, callback])

Downloads the specified range bytes of an object as a stream.

**Parameters**

| Param                   | Type       | Description                                                  |
| :---------------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`            | *string*   | Name of the bucket.                                          |
| `objectName`            | *string*   | Name of the object.                                          |
| `offset`                | *number*   | `offset` of the object from where the stream will start.     |
| `length`                | *number*   | `length` of the object that will be read in the stream (optional, if not specified we read the rest of the file from the offset). |
| `getOpts`               | *object*   | Version of the object in the form `{versionId:'my-versionId'}`. Default is `{}`. (optional) |
| `callback(err, stream)` | *function* | Callback is called with `err` in case of error. `stream` is the object content stream. If no callback is passed, a `Promise` is returned. |

**Return Value**

| Param    | Type     | Description                         |
| :------- | :------- | :---------------------------------- |
| `stream` | *Stream* | Stream emitting the object content. |

**Example**

```js
var size = 0
// reads 30 bytes from the offset 10.
ossClient.getPartialObject('mybucket', 'photo.jpg', 10, 30, function(err, dataStream) {
  if (err) {
    return console.log(err)
  }
  dataStream.on('data', function(chunk) {
    size += chunk.length
  })
  dataStream.on('end', function() {
    console.log('End. Total size = ' + size)
  })
  dataStream.on('error', function(err) {
    console.log(err)
  })
})
```

**Example**
To get a specific version of an object

```js
var versionedObjSize = 0
// reads 30 bytes from the offset 10.
ossClient.getPartialObject('mybucket', 'photo.jpg', 10, 30, {versionId:"my-versionId"}, function(err, dataStream) {
  if (err) {
    return console.log(err)
  }
  dataStream.on('data', function(chunk) {
      versionedObjSize += chunk.length
  })
  dataStream.on('end', function() {
    console.log('End. Total size = ' + versionedObjSize)
  })
  dataStream.on('error', function(err) {
    console.log(err)
  })
})
```



### fGetObject(bucketName, objectName, filePath, getOpts[, callback])

Downloads and saves the object as a file in the local filesystem.

**Parameters**

| Param           | Type       | Description                                                  |
| :-------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`    | *string*   | Name of the bucket.                                          |
| `objectName`    | *string*   | Name of the object.                                          |
| `filePath`      | *string*   | Path on the local filesystem to which the object data will be written. |
| `getOpts`       | *object*   | Version of the object in the form `{versionId:'my-versionId'}`. Default is `{}`. (optional) |
| `callback(err)` | *function* | Callback is called with `err` in case of error. If no callback is passed, a `Promise` is returned. |

**Return Value**

| Value  | Type     | Description                                      |
| :----- | :------- | :----------------------------------------------- |
| `err`  | *object* | Error in case of any failures                    |
| `file` | *file*   | Streamed Output file at the specified `filePath` |

**Example**

```js
var size = 0
ossClient.fGetObject('mybucket', 'photo.jpg', '/tmp/photo.jpg', function(err) {
  if (err) {
    return console.log(err)
  }
  console.log('success')
})
```

**Example**
To Stream a specific object version into a file.

```js
ossClient.fGetObject(bucketName, objNameValue, './download/MyImage.jpg', {versionId:"03fd1247-90d9-4b71-a27e-209d484a234b"}, function(e) {
  if (e) {
    return console.log(e)
  }
  console.log('success')
})
```



### putObject(bucketName, objectName, stream, size, metaData[, callback])

Uploads an object from a stream/Buffer.

##### From a stream

**Parameters**

| Param                    | Type                | Description                                                  |
| :----------------------- | :------------------ | :----------------------------------------------------------- |
| `bucketName`             | *string*            | Name of the bucket.                                          |
| `objectName`             | *string*            | Name of the object.                                          |
| `stream`                 | *Stream*            | Readable stream.                                             |
| `size`                   | *number*            | Size of the object (optional).                               |
| `metaData`               | *Javascript Object* | metaData of the object (optional).                           |
| `callback(err, objInfo)` | *function*          | Non-null `err` indicates error, in case of Success,`objInfo` contains `etag` *string* and `versionId` *string* of the object. If no callback is passed, a `Promise` is returned. |

**Return Value**

| Value               | Type     | Description                         |
| :------------------ | :------- | :---------------------------------- |
| `err`               | *object* | Error in case of any failures       |
| `objInfo.etag`      | *string* | `etag` of an object                 |
| `objInfo.versionId` | *string* | `versionId` of an object (optional) |

**Example**

The maximum size of a single object is limited to 5TB. putObject transparently uploads objects larger than 64MiB in multiple parts. Uploaded data is carefully verified using MD5SUM signatures.

```js
var Fs = require('fs')
var file = '/tmp/40mbfile'
var fileStream = Fs.createReadStream(file)
var fileStat = Fs.stat(file, function(err, stats) {
  if (err) {
    return console.log(err)
  }
  ossClient.putObject('mybucket', '40mbfile', fileStream, stats.size, function(err, objInfo) {
      if(err) {
          return console.log(err) // err should be null
      }
   console.log("Success", objInfo)
  })
})
```

##### From a "Buffer" or a "string"

**Parameters**

| Param                 | Type                 | Description                                                  |
| :-------------------- | :------------------- | :----------------------------------------------------------- |
| `bucketName`          | *string*             | Name of the bucket.                                          |
| `objectName`          | *string*             | Name of the object.                                          |
| `string or Buffer`    | *Stream* or *Buffer* | Readable stream.                                             |
| `metaData`            | *Javascript Object*  | metaData of the object (optional).                           |
| `callback(err, etag)` | *function*           | Non-null `err` indicates error, `etag` *string* is the etag of the object uploaded. |

**Example**

```js
var buffer = 'Hello World'
ossClient.putObject('mybucket', 'hello-file', buffer, function(err, etag) {
  return console.log(err, etag) // err should be null
})
```



### fPutObject(bucketName, objectName, filePath, metaData[, callback])

Uploads contents from a file to objectName.

**Parameters**

| Param                                                        | Type                | Description                      |
| :----------------------------------------------------------- | :------------------ | :------------------------------- |
| `bucketName`                                                 | *string*            | Name of the bucket.              |
| `objectName`                                                 | *string*            | Name of the object.              |
| `filePath`                                                   | *string*            | Path of the file to be uploaded. |
| `metaData`                                                   | *Javascript Object* | Metadata of the object.          |
| `callback(err, objInfo)` *function*: non null `err` indicates error, `objInfo` *object* is the information about the object uploaded which contains `versionId` string and `etag` string. |                     |                                  |

**Return Value**

| Value               | Type     | Description                         |
| :------------------ | :------- | :---------------------------------- |
| `err`               | *object* | Error in case of any failures       |
| `objInfo.etag`      | *string* | `etag` of an object                 |
| `objInfo.versionId` | *string* | `versionId` of an object (optional) |

**Example**

The maximum size of a single object is limited to 5TB. fPutObject transparently uploads objects larger than 64MiB in multiple parts. Uploaded data is carefully verified using MD5SUM signatures.

```js
var file = '/tmp/40mbfile'
var metaData = {
  'Content-Type': 'text/html',
  'Content-Language': 123,
  'X-Amz-Meta-Testing': 1234,
  'example': 5678
}
ossClient.fPutObject('mybucket', '40mbfile', file, metaData, function(err, objInfo) {
    if(err) {
        return console.log(err)
    }
    console.log("Success", objInfo.etag, objInfo.versionId)
})
```



### copyObject(bucketName, objectName, sourceObject, conditions[, callback])

Copy a source object into a new object in the specified bucket.

**Parameters**

| Param                                 | Type             | Description                                                  |
| :------------------------------------ | :--------------- | :----------------------------------------------------------- |
| `bucketName`                          | *string*         | Name of the bucket.                                          |
| `objectName`                          | *string*         | Name of the object.                                          |
| `sourceObject`                        | *string*         | Path of the file to be copied.                               |
| `conditions`                          | *CopyConditions* | Conditions to be satisfied before allowing object copy.      |
| `callback(err, {etag, lastModified})` | *function*       | Non-null `err` indicates error, `etag` *string* and lastModified *Date* are the etag and the last modified date of the object newly copied. If no callback is passed, a `Promise` is returned. |

**Example**

```js
var conds = new OSS.CopyConditions()
conds.setMatchETag('bd891862ea3e22c93ed53a098218791d')
ossClient.copyObject('mybucket', 'newobject', '/mybucket/srcobject', conds, function(e, data) {
  if (e) {
    return console.log(e)
  }
  console.log("Successfully copied the object:")
  console.log("etag = " + data.etag + ", lastModified = " + data.lastModified)
})
```



### statObject(bucketName, objectName, statOpts[, callback])

Gets metadata of an object.

**Parameters**

| Param                 | Type       | Description                                                  |
| :-------------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`          | *string*   | Name of the bucket.                                          |
| `objectName`          | *string*   | Name of the object.                                          |
| `statOpts`            | *object*   | Version of the object in the form `{versionId:"my-versionId"}`. Default is `{}`. (optional) |
| `callback(err, stat)` | *function* | `err` is not `null` in case of error, `stat` contains the object information listed below. If no callback is passed, a `Promise` is returned. |

**Return Value**

| Param               | Type                | Description               |
| :------------------ | :------------------ | :------------------------ |
| `stat.size`         | *number*            | size of the object.       |
| `stat.etag`         | *string*            | etag of the object.       |
| `stat.versionId`    | *string*            | version of the object.    |
| `stat.metaData`     | *Javascript Object* | metadata of the object.   |
| `stat.lastModified` | *Date*              | Last Modified time stamp. |

**Example**

```js
ossClient.statObject('mybucket', 'photo.jpg', function(err, stat) {
  if (err) {
    return console.log(err)
  }
  console.log(stat)
})
```

**Example stat on a version of an object**

```js
ossClient.statObject('mybucket', 'photo.jpg', { versionId : "uuid" }, function(err, stat) {
  if (err) {
    return console.log(err)
  }
  console.log(stat)
})
```



### removeObject(bucketName, objectName, removeOpts[, callback])

Removes an object.

**Parameters**

| Param           | Type       | Description                                                  |
| :-------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`    | *string*   | Name of the bucket.                                          |
| objectName      | *string*   | Name of the object.                                          |
| removeOpts      | *object*   | Version of the object in the form `{versionId:"my-versionId"}`. Default is `{}`. (optional) |
| `callback(err)` | *function* | Callback function is called with non `null` value in case of error. If no callback is passed, a `Promise` is returned. |

**Example**

```js
ossClient.removeObject('mybucket', 'photo.jpg', function(err) {
  if (err) {
    return console.log('Unable to remove object', err)
  }
  console.log('Removed the object')
})
```

**Example delete a specific version of an oject**

```js
ossClient.removeObject('mybucket', 'photo.jpg', { versionId : "uuid" }, function(err) {
  if (err) {
    return console.log('Unable to remove object', err)
  }
  console.log('Removed the object')
})
```



### removeObjects(bucketName, objectsList[, callback])

Remove all objects in the objectsList.

**Parameters**

| Param           | Type       | Description                                                  |
| :-------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`    | *string*   | Name of the bucket.                                          |
| `objectsList`   | *object*   | list of objects in the bucket to be removed. any one of the formats: 1. List of Object names as array of strings which are object keys: `['objectname1','objectname2']` 2. List of Object name and VersionId as an object: [{name:"my-obj-name",versionId:"my-version-id"}] |
| `callback(err)` | *function* | Callback function is called with non `null` value in case of error. |

**Example**

```js
var objectsList = []

// List all object paths in bucket my-bucketname.
var objectsStream = s3Client.listObjects('my-bucketname', 'my-prefixname', true)

objectsStream.on('data', function(obj) {
  objectsList.push(obj.name);
})

objectsStream.on('error', function(e) {
  console.log(e);
})

objectsStream.on('end', function() {

  s3Client.removeObjects('my-bucketname',objectsList, function(e) {
    if (e) {
        return console.log('Unable to remove Objects ',e)
    }
    console.log('Removed the objects successfully')
  })

})
```

**Example 1**

With versioning Support

```js
var objectsList=[]
var bucket ="my-bucket"
var prefix="my-prefix"
var recursive=false

var objectsStream = s3Client.listObjects(bucket, prefix, recursive, {IncludeVersion: true})
  objectsStream.on('data', function (obj) {
      objectsList.push(obj)
  })
  objectsStream.on('error', function (e) {
    return console.log(e)
  })
  objectsStream.on('end', function () {
    s3Client.removeObjects(bucket, objectsList, function (e) {
      if (e) {
        return console.log(e)
      }
      console.log("Success")
    })
  })
```



### removeIncompleteUpload(bucketName, objectName[, callback])

Removes a partially uploaded object.

**Parameters**

| Param           | Type       | Description                                                  |
| :-------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`    | *string*   | Name of the bucket.                                          |
| `objectName`    | *string*   | Name of the object.                                          |
| `callback(err)` | *function* | Callback function is called with non `null` value in case of error. If no callback is passed, a `Promise` is returned. |

**Example**

```js
ossClient.removeIncompleteUpload('mybucket', 'photo.jpg', function(err) {
  if (err) {
    return console.log('Unable to remove incomplete object', err)
  }
  console.log('Incomplete object removed successfully.')
})
```

## 4. Presigned operations

Presigned URLs are generated for temporary download/upload access to private objects.



### presignedUrl(httpMethod, bucketName, objectName[, expiry, reqParams, requestDate, cb])

Generates a presigned URL for the provided HTTP method, 'httpMethod'. Browsers/Mobile clients may point to this URL to directly download objects even if the bucket is private. This presigned URL can have an associated expiration time in seconds after which the URL is no longer valid. The default value is 7 days.

**Parameters**

| Param                         | Type       | Description                                                  |
| :---------------------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`                  | *string*   | Name of the bucket.                                          |
| `objectName`                  | *string*   | Name of the object.                                          |
| `expiry`                      | *number*   | Expiry time in seconds. Default value is 7 days. (optional)  |
| `reqParams`                   | *object*   | request parameters. (optional)                               |
| `requestDate`                 | *Date*     | A date object, the url will be issued at. Default value is now. (optional) |
| `callback(err, presignedUrl)` | *function* | Callback function is called with non `null` err value in case of error. `presignedUrl` will be the URL using which the object can be downloaded using GET request. If no callback is passed, a `Promise` is returned. |

**Example 1**

```js
//presigned url for 'getObject' method.
// expires in a day.
ossClient.presignedUrl('GET', 'mybucket', 'hello.txt', 24*60*60, function(err, presignedUrl) {
  if (err) return console.log(err)
  console.log(presignedUrl)
})
```

**Example 2**

```js
//presigned url for 'listObject' method.
// Lists objects in 'myBucket' with prefix 'data'.
// Lists max 1000 of them.
ossClient.presignedUrl('GET', 'mybucket', '', 1000, {'prefix': 'data', 'max-keys': 1000}, function(err, presignedUrl) {
  if (err) return console.log(err)
  console.log(presignedUrl)
})
```



### presignedGetObject(bucketName, objectName[, expiry, respHeaders, requestDate, cb])

Generates a presigned URL for HTTP GET operations. Browsers/Mobile clients may point to this URL to directly download objects even if the bucket is private. This presigned URL can have an associated expiration time in seconds after which the URL is no longer valid. The default value is 7 days.

**Parameters**

| Param                         | Type       | Description                                                  |
| :---------------------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`                  | *string*   | Name of the bucket.                                          |
| `objectName`                  | *string*   | Name of the object.                                          |
| `expiry`                      | *number*   | Expiry time in seconds. Default value is 7 days. (optional)  |
| `respHeaders`                 | *object*   | response headers to override (optional)                      |
| `requestDate`                 | *Date*     | A date object, the url will be issued at. Default value is now. (optional) |
| `callback(err, presignedUrl)` | *function* | Callback function is called with non `null` err value in case of error. `presignedUrl` will be the URL using which the object can be downloaded using GET request. If no callback is passed, a `Promise` is returned. |

**Example**

```js
//expires in a day.
ossClient.presignedGetObject('mybucket', 'hello.txt', 24*60*60, function(err, presignedUrl) {
  if (err) return console.log(err)
  console.log(presignedUrl)
})
```



### presignedPutObject(bucketName, objectName, expiry[, callback])

Generates a presigned URL for HTTP PUT operations. Browsers/Mobile clients may point to this URL to upload objects directly to a bucket even if it is private. This presigned URL can have an associated expiration time in seconds after which the URL is no longer valid. The default value is 7 days.

**Parameters**

| Param                         | Type       | Description                                                  |
| :---------------------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`                  | *string*   | Name of the bucket.                                          |
| `objectName`                  | *string*   | Name of the object.                                          |
| `expiry`                      | *number*   | Expiry time in seconds. Default value is 7 days.             |
| `callback(err, presignedUrl)` | *function* | Callback function is called with non `null` err value in case of error. `presignedUrl` will be the URL using which the object can be uploaded using PUT request. If no callback is passed, a `Promise` is returned. |

**Example**

```js
//expires in a day.
ossClient.presignedPutObject('mybucket', 'hello.txt', 24*60*60, function(err, presignedUrl) {
  if (err) return console.log(err)
  console.log(presignedUrl)
})
```



### presignedPostPolicy(policy[, callback])

Allows setting policy conditions to a presigned URL for POST operations. Policies such as bucket name to receive object uploads, key name prefixes, expiry policy may be set.

**Parameters**

| Param                                | Type       | Description                                                  |
| :----------------------------------- | :--------- | :----------------------------------------------------------- |
| `policy`                             | *object*   | Policy object created by ossClient.newPostPolicy()           |
| `callback(err, {postURL, formData})` | *function* | Callback function is called with non `null` err value in case of error. `postURL` will be the URL using which the object can be uploaded using POST request. `formData` is the object having key/value pairs for the Form data of POST body. If no callback is passed, a `Promise` is returned. |

Create policy:

```js
var policy = ossClient.newPostPolicy()
```

Apply upload policy restrictions:

```js
//Policy restricted only for bucket 'mybucket'.
policy.setBucket('mybucket')

// Policy restricted only for hello.txt object.
policy.setKey('hello.txt')
```

or

```js
//Policy restricted for incoming objects with keyPrefix.
policy.setKeyStartsWith('keyPrefix')

var expires = new Date
expires.setSeconds(24 * 60 * 60 * 10)
// Policy expires in 10 days.
policy.setExpires(expires)

// Only allow 'text'.
policy.setContentType('text/plain')

// Only allow content size in range 1KB to 1MB.
policy.setContentLengthRange(1024, 1024*1024)
```

POST your content from the browser using `superagent`:

```JS
ossClient.presignedPostPolicy(policy, function(err, data) {
  if (err) return console.log(err)

  var req = superagent.post(data.postURL)
  _.each(data.formData, function(value, key) {
    req.field(key, value)
  })

  // file contents.
  req.attach('file', '/path/to/hello.txt', 'hello.txt')

  req.end(function(err, res) {
    if (err) {
      return console.log(err.toString())
    }
    console.log('Upload successful.')
  })
})
```

## 5. Bucket Policy & Notification operations

Buckets are configured to trigger notifications on specified types of events and paths filters.



### getBucketNotification(bucketName[, cb])

Fetch the notification configuration stored in the S3 provider and that belongs to the specified bucket name.

**Parameters**

| Param                                     | Type       | Description                                                  |
| :---------------------------------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`                              | *string*   | Name of the bucket.                                          |
| `callback(err, bucketNotificationConfig)` | *function* | Callback function is called with non `null` err value in case of error. `bucketNotificationConfig` will be the object that carries all notification configurations associated to bucketName. If no callback is passed, a `Promise` is returned. |

**Example**

```js
ossClient.getBucketNotification('mybucket', function(err, bucketNotificationConfig) {
  if (err) return console.log(err)
  console.log(bucketNotificationConfig)
})
```



### setBucketNotification(bucketName, bucketNotificationConfig[, callback])

Upload a user-created notification configuration and associate it to the specified bucket name.

**Parameters**

| Param                      | Type                 | Description                                                  |
| :------------------------- | :------------------- | :----------------------------------------------------------- |
| `bucketName`               | *string*             | Name of the bucket.                                          |
| `bucketNotificationConfig` | *BucketNotification* | Javascript object that carries the notification configuration. |
| `callback(err)`            | *function*           | Callback function is called with non `null` err value in case of error. If no callback is passed, a `Promise` is returned. |

**Example**

```js
//Create a new notification object
var bucketNotification = new OSS.NotificationConfig();

// Setup a new Queue configuration
var arn = OSS.buildARN('aws', 'sqs', 'us-west-2', '1', 'webhook')
var queue = new OSS.QueueConfig(arn)
queue.addFilterSuffix('.jpg')
queue.addFilterPrefix('myphotos/')
queue.addEvent(OSS.ObjectReducedRedundancyLostObject)
queue.addEvent(OSS.ObjectCreatedAll)

// Add the queue to the overall notification object
bucketNotification.add(queue)

ossClient.setBucketNotification('mybucket', bucketNotification, function(err) {
  if (err) return console.log(err)
  console.log('Success')
})
```



### removeAllBucketNotification(bucketName[, callback])

Remove the bucket notification configuration associated to the specified bucket.

**Parameters**

| Param           | Type       | Description                                                  |
| :-------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`    | *string*   | Name of the bucket                                           |
| `callback(err)` | *function* | Callback function is called with non `null` err value in case of error. If no callback is passed, a `Promise` is returned. |

```js
ossClient.removeAllBucketNotification('my-bucketname', function(e) {
  if (e) {
    return console.log(e)
  }
  console.log("True")
})
```



### listenBucketNotification(bucketName, prefix, suffix, events)

Listen for notifications on a bucket. Additionally one can provider
filters for prefix, suffix and events. There is no prior set bucket notification
needed to use this API. This is an OSS extension API where unique identifiers
are registered and unregistered by the server automatically based on incoming requests.

Returns an `EventEmitter`, which will emit a `notification` event carrying the record.

To stop listening, call `.stop()` on the returned `EventEmitter`.

**Parameters**

| Param        | Type     | Description                                     |
| :----------- | :------- | :---------------------------------------------- |
| `bucketName` | *string* | Name of the bucket                              |
| `prefix`     | *string* | Object key prefix to filter notifications for.  |
| `suffix`     | *string* | Object key suffix to filter notifications for.  |
| `events`     | *Array*  | Enables notifications for specific event types. |

See  example.

```js
var listener = ossClient.listenBucketNotification('my-bucketname', 'photos/', '.jpg', ['s3:ObjectCreated:*'])
listener.on('notification', function(record) {
  // For example: 's3:ObjectCreated:Put event occurred (2016-08-23T18:26:07.214Z)'
  console.log('%s event occurred (%s)', record.eventName, record.eventTime)
  listener.stop()
})
```



### getBucketPolicy(bucketName [, callback])

Get the bucket policy associated with the specified bucket. If `objectPrefix`
is not empty, the bucket policy will be filtered based on object permissions
as well.

**Parameters**

| Param                   | Type       | Description                                                  |
| :---------------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`            | *string*   | Name of the bucket                                           |
| `callback(err, policy)` | *function* | Callback function is called with non `null` err value in case of error. `policy` is [bucket policy](https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html). If no callback is passed, a `Promise` is returned. |

```js
//Retrieve bucket policy of 'my-bucketname'
ossClient.getBucketPolicy('my-bucketname', function(err, policy) {
  if (err) throw err

  console.log(`Bucket policy file: ${policy}`)
})
```



### setBucketPolicy(bucketName, bucketPolicy[, callback])

Set the bucket policy on the specified bucket. [bucketPolicy](https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html) is detailed here.

**Parameters**

| Param           | Type       | Description                                                  |
| :-------------- | :--------- | :----------------------------------------------------------- |
| `bucketName`    | *string*   | Name of the bucket.                                          |
| `bucketPolicy`  | *string*   | bucket policy.                                               |
| `callback(err)` | *function* | Callback function is called with non `null` err value in case of error. If no callback is passed, a `Promise` is returned. |

```js
//Set the bucket policy of `my-bucketname`
ossClient.setBucketPolicy('my-bucketname', JSON.stringify(policy), function(err) {
  if (err) throw err

  console.log('Bucket policy set')
})
```

## 6. HTTP request options

### setRequestOptions(options)

Set the HTTP/HTTPS request options. Supported options are `agent` ([http.Agent()](https://nodejs.org/api/http.html#http_class_http_agent)), `family` ([IP address family to use while resolving `host` or `hostname`](https://nodejs.org/api/http.html#http_http_request_url_options_callback)), and tls related options ('agent', 'ca', 'cert', 'ciphers', 'clientCertEngine', 'crl', 'dhparam', 'ecdhCurve', 'honorCipherOrder', 'key', 'passphrase', 'pfx', 'rejectUnauthorized', 'secureOptions', 'secureProtocol', 'servername', 'sessionIdContext') documented [here](https://nodejs.org/api/tls.html#tls_tls_createsecurecontext_options)

```js
//Do not reject self signed certificates.
ossClient.setRequestOptions({rejectUnauthorized: false})
```

