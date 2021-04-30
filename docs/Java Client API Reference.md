# Java Client API Reference

OSS Java SDK is Simple Storage Service (aka S3) client to perform bucket and object operations to any Amazon S3 compatible object storage service.

## Minimum Requirements

Java 1.8 or above.

## Maven usage

```xml
    <repositories>
        <!--公司环境依赖私服-->
        <repository>
            <releases>
                <enabled>false</enabled>
            </releases>
            <snapshots>
                <enabled>true</enabled>
                <updatePolicy>never</updatePolicy>
            </snapshots>
            <id>distsnapshots</id>
            <name>libs-snapshot</name>
            <url>http://elb-791125809.cn-northwest-1.elb.amazonaws.com.cn:5336/artifactory/libs-snapshot</url>
        </repository>
    </repositories>

<!--OSS 文件存储客户端依赖-->
<dependency>
    <groupId>com.dist.zja</groupId>
    <artifactId>spring-boot-starter-oss</artifactId>
    <version>8.0-SNAPSHOT</version>
    <scope>compile</scope>
</dependency>
```

springboot config  *.yaml

```yaml
dist:
  oss:
    config:
      enabled: true  # 默认true
      secure: false  # 是否启动 https 访问, 默认 false
      endpoint: http://127.0.0.1
      port: 9000
      accessKey: username
      secretKey: password
      default-bucket: mybucket # 可选，仅支持小写字母,长度必须大于3个字符,默认桶会自动创建
```

## Quick example Test

```java
    @Autowired
    OSSClient ossClient; // 默认客户端

    @Test(expected = IllegalArgumentException.class)
    public void test1() throws IOException, InvalidKeyException, InvalidResponseException, InsufficientDataException, NoSuchAlgorithmException, ServerException, InternalException, XmlParserException, ErrorResponseException {
        //手动创建客户端
        OSSClient client =
                OSSClient.builder()
                        .endpoint("http://127.0.0.1:9000")
                        .build();

        client.makeBucket(MakeBucketArgs.builder().bucket("mybucket1").build());
    }

    @Test(expected = IllegalArgumentException.class)
    public void test2() throws IOException, InvalidKeyException, InvalidResponseException, InsufficientDataException, NoSuchAlgorithmException, ServerException, InternalException, XmlParserException, ErrorResponseException {
        //默认客户端 判断桶
        boolean result = ossClient.bucketExists(BucketExistsArgs.builder().bucket("mybucket").build());
        log.error("test2-result：{}", result);
    }
```



## Create OSS Client.

## OSS

```java
OSSClient ossClient =
    OSSClient.builder()
        .endpoint("https://127.0.0.1")
        .credentials("username", "password")
        .build();
```

## AWS S3

```java
OSSClient ossClient =
    OSSClient.builder()
        .endpoint("https://s3.amazonaws.com")
        .credentials("YOUR-ACCESSKEYID", "YOUR-SECRETACCESSKEY")
        .build();
```


| Bucket operations               | Object operations          |
| :------------------------------ | :------------------------- |
| `bucketExists`                  | `composeObject`            |
| `deleteBucketEncryption`        | `copyObject`               |
| `deleteBucketLifecycle`         | `deleteObjectTags`         |
| `deleteBucketNotification`      | `disableObjectLegalHold`   |
| `deleteBucketPolicy`            | `downloadObject`           |
| `deleteBucketReplication`       | `enableObjectLegalHold`    |
| `deleteBucketTags`              | `getObject`                |
| `deleteObjectLockConfiguration` | `getObjectRetention`       |
| `getBucketEncryption`           | `getObjectTags`            |
| `getBucketLifecycle`            | `getPresignedObjectUrl`    |
| `getBucketNotification`         | `getPresignedPostFormData` |
| `getBucketPolicy`               | `isObjectLegalHoldEnabled` |
| `getBucketReplication`          | `listObjects`              |
| `getBucketTags`                 | `putObject`                |
| `getBucketVersioning`           | `removeObject`             |
| `getObjectLockConfiguration`    | `removeObjects`            |
| `listBuckets`                   | `selectObjectContent`      |
| `listenBucketNotification`      | `setObjectRetention`       |
| `makeBucket`                    | `setObjectTags`            |
| `removeBucket`                  | `statObject`               |
| `setBucketEncryption`           | `uploadObject`             |
| `setBucketLifecycle`            |                            |
| `setBucketNotification`         |                            |
| `setBucketPolicy`               |                            |
| `setBucketReplication`          |                            |
| `setBucketTags`                 |                            |
| `setBucketVersioning`           |                            |
| `setObjectLockConfiguration`    |                            |



## 1. OSS Client Builder

OSS Client Builder is used to create OSS client. Builder has below methods to accept arguments.
| Method | Description |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| `endpoint()` | Accepts endpoint as a String, URL or okhttp3.HttpUrl object and optionally accepts port number and flag to enable secure (TLS) connection. |
| | Endpoint as a string can be formatted like below: |
| | `https://s3.amazonaws.com` |
| | `https://127.0.0.1` |
| | `https://127.0.0.1:9000` |
| | `localhost` |
| | `127.0.0.1` |
| `credentials()` | Accepts access key (aka user ID) and secret key (aka password) of an account in S3 service. |
| `region()` | Accepts region name of S3 service. If specified, all operations use this region otherwise region is probed per bucket. |
| `httpClient()` | Custom HTTP client to override default. |



**Examples**

### OSS

```java
// 1. Create client to S3 service '127.0.0.1' at port 443 with TLS security
// for anonymous access.
OSSClient ossClient = OSSClient.builder().endpoint("https://127.0.0.1").build();

// 2. Create client to S3 service '127.0.0.1' at port 443 with TLS security
// using URL object for anonymous access.
OSSClient ossClient = OSSClient.builder().endpoint(new URL("https://127.0.0.1")).build();

// 3. Create client to S3 service '127.0.0.1' at port 9000 with TLS security
// using okhttp3.HttpUrl object for anonymous access.
OSSClient ossClient =
    OSSClient.builder().endpoint(HttpUrl.parse("https://127.0.0.1:9000")).build();

// 4. Create client to S3 service '127.0.0.1' at port 443 with TLS security
// for authenticated access.
OSSClient ossClient =
    OSSClient.builder()
        .endpoint("https://127.0.0.1")
        .credentials("username", "password")
        .build();

// 5. Create client to S3 service '127.0.0.1' at port 9000 with non-TLS security
// for authenticated access.
OSSClient ossClient =
    OSSClient.builder()
        .endpoint("127.0.0.1", 9000, false)
        .credentials("username", "password")
        .build();

// 6. Create client to S3 service '127.0.0.1' at port 9000 with TLS security
// for authenticated access.
OSSClient ossClient =
    OSSClient.builder()
        .endpoint("127.0.0.1", 9000, true)
        .credentials("username", "password")
        .build();

// 7. Create client to S3 service '127.0.0.1' at port 443 with TLS security
// and region 'us-west-1' for authenticated access.
OSSClient ossClient =
    OSSClient.builder()
        .endpoint(new URL("https://127.0.0.1"))
        .credentials("username", "password")
        .region("us-west-1")
        .build();

// 8. Create client to S3 service '127.0.0.1' at port 9000 with TLS security,
// region 'eu-east-1' and custom HTTP client for authenticated access.
OSSClient ossClient =
    OSSClient.builder()
        .endpoint("https://127.0.0.1:9000")
        .credentials("username", "password")
        .region("eu-east-1")
        .httpClient(customHttpClient)
        .build();
```

### AWS S3

```java
// 1. Create client to S3 service 's3.amazonaws.com' at port 443 with TLS security
// for anonymous access.
OSSClient s3Client = OSSClient.builder().endpoint("https://s3.amazonaws.com").build();

// 2. Create client to S3 service 's3.amazonaws.com' at port 443 with TLS security
// using URL object for anonymous access.
OSSClient s3Client = OSSClient.builder().endpoint(new URL("https://s3.amazonaws.com")).build();

// 3. Create client to S3 service 's3.amazonaws.com' at port 9000 with TLS security
// using okhttp3.HttpUrl object for anonymous access.
OSSClient s3Client =
    OSSClient.builder().endpoint(HttpUrl.parse("https://s3.amazonaws.com")).build();

// 4. Create client to S3 service 's3.amazonaws.com' at port 80 with TLS security
// for authenticated access.
OSSClient s3Client =
    OSSClient.builder()
        .endpoint("s3.amazonaws.com")
        .credentials("YOUR-ACCESSKEYID", "YOUR-SECRETACCESSKEY")
        .build();

// 5. Create client to S3 service 's3.amazonaws.com' at port 443 with non-TLS security
// for authenticated access.
OSSClient s3Client =
    OSSClient.builder()
        .endpoint("s3.amazonaws.com", 433, false)
        .credentials("YOUR-ACCESSKEYID", "YOUR-SECRETACCESSKEY")
        .build();

// 6. Create client to S3 service 's3.amazonaws.com' at port 80 with non-TLS security
// for authenticated access.
OSSClient s3Client =
    OSSClient.builder()
        .endpoint("s3.amazonaws.com", 80, false)
        .credentials("YOUR-ACCESSKEYID", "YOUR-SECRETACCESSKEY")
        .build();

// 7. Create client to S3 service 's3.amazonaws.com' at port 80 with TLS security
// for authenticated access.
OSSClient s3Client =
    OSSClient.builder()
        .endpoint("s3.amazonaws.com", 80, true)
        .credentials("YOUR-ACCESSKEYID", "YOUR-SECRETACCESSKEY")
        .build();

// 8. Create client to S3 service 's3.amazonaws.com' at port 80 with non-TLS security
// and region 'us-west-1' for authenticated access.
OSSClient s3Client =
    OSSClient.builder()
        .endpoint("s3.amazonaws.com", 80, false)
        .credentials("YOUR-ACCESSKEYID", "YOUR-SECRETACCESSKEY")
        .region("us-west-1")
        .build();

// 9. Create client to S3 service 's3.amazonaws.com' at port 443 with TLS security
// and region 'eu-west-2' for authenticated access.
OSSClient s3Client =
    OSSClient.builder()
        .endpoint("s3.amazonaws.com", 443, true)
        .credentials("YOUR-ACCESSKEYID", "YOUR-SECRETACCESSKEY").
        .region("eu-west-2")
        .build();

// 10. Create client to S3 service 's3.amazonaws.com' at port 443 with TLS security,
// region 'eu-central-1' and custom HTTP client for authenticated access.
OSSClient s3Client =
    OSSClient.builder()
        .endpoint("s3.amazonaws.com", 443, true)
        .credentials("YOUR-ACCESSKEYID", "YOUR-SECRETACCESSKEY")
        .region("eu-central-1")
        .httpClient(customHttpClient)
        .build();
```

## Common Exceptions

All APIs throw below exceptions in addition to specific to API.

| Exception                 | Cause                                                        |
| :------------------------ | :----------------------------------------------------------- |
| ErrorResponseException    | Thrown to indicate S3 service returned an error response.    |
| IllegalArgumentException  | Throws to indicate invalid argument passed.                  |
| InsufficientDataException | Thrown to indicate not enough data available in InputStream. |
| InternalException         | Thrown to indicate internal library error.                   |
| InvalidKeyException       | Thrown to indicate missing of HMAC SHA-256 library.          |
| InvalidResponseException  | Thrown to indicate S3 service returned invalid or no error response. |
| IOException               | Thrown to indicate I/O error on S3 operation.                |
| NoSuchAlgorithmException  | Thrown to indicate missing of MD5 or SHA-256 digest library. |
| ServerException           | Thrown to indicate HTTP server error.                        |
| XmlParserException        | Thrown to indicate XML parsing error.                        |

## 2. Bucket operations



### bucketExists(BucketExistsArgs args)

`public boolean bucketExists(BucketExistsArgs args)` 

Checks if a bucket exists.

**Parameters**

| Parameter | Type | Description |
| :---------------|:---------------------|:--------------- |
| `bucketName` | BucketExistsArgs | Arguments. |

| Returns                                | |
| :------------------------------------- | ----------------: |
| *boolean* - True if the bucket exists. | |

**Example**

```java
// Check whether 'my-bucketname' exists or not.
boolean found = 
  ossClient.bucketExists(BucketExistsArgs.builder().bucket("my-bucketname").build());
if (found) {
  System.out.println("my-bucketname exists");
} else {
  System.out.println("my-bucketname does not exist");
}
```



### deleteBucketEncryption(DeleteBucketEncryptionArgs args)

`private void deleteBucketEncryption(DeleteBucketEncryptionArgs args)` 

Deletes encryption configuration of a bucket.

**Parameters**

| Parameter | Type | Description |
|:----------|:-------------------------------|:------------|
| `args` | DeleteBucketEncryptionArgs | Arguments. |

**Example**

```java
ossClient.deleteBucketEncryption(
    DeleteBucketEncryptionArgs.builder().bucket("my-bucketname").build());
```



### deleteBucketLifecycle(DeleteBucketLifecycleArgs args)

`private void deleteBucketLifecycle(DeleteBucketLifecycleArgs args)` 

Deletes lifecycle configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:------------------------------|:------------|
| `args` | DeleteBucketLifecycleArgs | Arguments. |

**Example**

```java
ossClient.deleteBucketLifecycle(
    DeleteBucketLifecycleArgs.builder().bucket("my-bucketname").build());
```



### deleteBucketTags(DeleteBucketTagsArgs args)

`private void deleteBucketTags(DeleteBucketTagsArgs args)` 

Deletes tags of a bucket.

**Parameters**

| Parameter | Type | Description |
|:----------|:-------------------------|:------------|
| `args` | DeleteBucketTagsArgs | Arguments. |

**Example**

```java
ossClient.deleteBucketTags(DeleteBucketTagsArgs.builder().bucket("my-bucketname").build());
```



### deleteBucketPolicy(DeleteBucketPolicyArgs args)

`private void deleteBucketPolicy(DeleteBucketPolicyArgs args)` 

Deletes bucket policy configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:---------------------------|:------------|
| `args` | DeleteBucketPolicyArgs | Arguments. |

**Example**

```java
ossClient.deleteBucketPolicy(DeleteBucketPolicyArgs.builder().bucket("my-bucketname").build());
```



### deleteBucketReplication(DeleteBucketReplicationArgs args)

`private void deleteBucketReplication(DeleteBucketReplicationArgs args)` 

Deletes bucket replication configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:--------------------------------|:------------|
| `args` | DeleteBucketReplicationArgs | Arguments. |

**Example**

```java
ossClient.deleteBucketReplication(
    DeleteBucketReplicationArgs.builder().bucket("my-bucketname").build());
```



### deleteBucketNotification(DeleteBucketNotificationArgs args)

`public void deleteBucketNotification(DeleteBucketNotificationArgs args)` 

Deletes notification configuration of a bucket.

**Parameters**

| Parameter | Type | Description |
|:----------|:---------------------------------|:------------|
| `args` | DeleteBucketNotificationArgs | Arguments. |

**Example**

```java
ossClient.deleteBucketNotification(
    DeleteBucketNotificationArgs.builder().bucket("my-bucketname").build());
```



### deleteObjectLockConfiguration(DeleteObjectLockConfigurationArgs args)

`public void deleteObjectLockConfiguration(DeleteObjectLockConfigurationArgs args)` 

Deletes object-lock configuration in a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:--------------------------------------|:------------|
| `args` | DeleteObjectLockConfigurationArgs | Arguments. |

**Example**

```java
ossClient.deleteObjectLockConfiguration(
    DeleteObjectLockConfigurationArgs.builder().bucket("my-bucketname").build());
```



### getBucketEncryption(GetBucketEncryptionArgs args)

`public SseConfiguration getBucketEncryption(GetBucketEncryptionArgs args)` 

Gets encryption configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:----------------------------|:------------|
| `args` | GetBucketEncryptionArgs | Arguments. |

| Returns                                                 |
| :------------------------------------------------------ |
| SseConfiguration- Server-side encryption configuration. |

**Example**

```java
SseConfiguration config =
    ossClient.getBucketEncryption(
        GetBucketEncryptionArgs.builder().bucket("my-bucketname").build());
```



### getBucketLifecycle(GetBucketLifecycleArgs args)

`public LifecycleConfiguration getBucketLifecycle(GetBucketLifecycleArgs args)` 

Gets lifecycle configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:---------------------------|:------------|
| `args` | GetBucketLifecycleArgs | Arguments. |

| Returns                                           |
| :------------------------------------------------ |
| LifecycleConfiguration - lifecycle configuration. |

**Example**

```java
LifecycleConfiguration config =
    ossClient.getBucketLifecycle(
        GetBucketLifecycleArgs.builder().bucket("my-bucketname").build());
System.out.println("Lifecycle configuration: " + config);
```



### getBucketNotification(GetBucketNotificationArgs args)

`public NotificationConfiguration getBucketNotification(GetBucketNotificationArgs args)` 

Gets notification configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:------------------------------|:------------|
| `args` | GetBucketNotificationArgs | Arguments. |

| Returns                                                 |
| :------------------------------------------------------ |
| NotificationConfiguration - Notification configuration. |

**Example**

```java
NotificationConfiguration config =
    ossClient.getBucketNotification(
        GetBucketNotificationArgs.builder().bucket("my-bucketname").build());
```



### getBucketPolicy(GetBucketPolicyArgs args)

`public String getBucketPolicy(GetBucketPolicyArgs args)`

Gets bucket policy configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:------------------------|:------------|
| `args` | GetBucketPolicyArgs | Arguments. |

| Returns                                                |
| :----------------------------------------------------- |
| *String* - Bucket policy configuration as JSON string. |

**Example**

```java
String config =
    ossClient.getBucketPolicy(GetBucketPolicyArgs.builder().bucket("my-bucketname").build());
```



### getBucketReplication(GetBucketReplicationArgs args)

`public ReplicationConfiguration getBucketReplication(GetBucketReplicationArgs args)` 

Gets bucket replication configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:-----------------------------|:------------|
| `args` | GetBucketReplicationArgs | Arguments. |

| Returns                                                      |
| :----------------------------------------------------------- |
| ReplicationConfiguration - Bucket replication configuration. |

**Example**

```java
ReplicationConfiguration config =
    ossClient.getBucketReplication(
        GetBucketReplicationArgs.builder().bucket("my-bucketname").build());
```



### getBucketTags(GetBucketTagsArgs args)

`public Tags getBucketTags(GetBucketTagsArgs args)` 

Gets tags of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:----------------------|:------------|
| `args` | GetBucketTagsArgs | Arguments. |

| Returns      |
| :----------- |
| Tags - tags. |

**Example**

```java
Tags tags = ossClient.getBucketTags(GetBucketTagsArgs.builder().bucket("my-bucketname").build());
```



### getBucketVersioning(GetBucketVersioningArgs args)

`public VersioningConfiguration getBucketVersioning(GetBucketVersioningArgs args)` 

Gets versioning configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:----------------------------|:------------|
| `args` | GetBucketVersioningArgs | Arguments. |

| Returns                                             |
| :-------------------------------------------------- |
| VersioningConfiguration - Versioning configuration. |

**Example**

```java
VersioningConfiguration config =
    ossClient.getBucketVersioning(
        GetBucketVersioningArgs.builder().bucket("my-bucketname").build());
```



### getObjectLockConfiguration(GetObjectLockConfigurationArgs args)

`public ObjectLockConfiguration getObjectLockConfiguration(GetObjectLockConfigurationArgs args)` 

Gets object-lock configuration in a bucket.

**Parameters**

| Parameter | Type                           | Description |
| :-------- | :----------------------------- | :---------- |
| `args`    | GetObjectLockConfigurationArgs | Arguments.  |

| Returns                                                    |
| :--------------------------------------------------------- |
| ObjectLockConfiguration - Default retention configuration. |

**Example**

```java
ObjectLockConfiguration config =
    ossClient.getObjectLockConfiguration(
        GetObjectLockConfigurationArgs.builder().bucket("my-bucketname").build());
System.out.println("Mode: " + config.mode());
System.out.println("Duration: " + config.duration().duration() + " " + config.duration().unit());
```



### listBuckets()

`public List<Bucket> listBuckets()` 

Lists bucket information of all buckets.

| Returns                                      |
| :------------------------------------------- |
| *List<Bucket>* - List of bucket information. |

**Example**

```java
List<Bucket> bucketList = ossClient.listBuckets();
for (Bucket bucket : bucketList) {
  System.out.println(bucket.creationDate() + ", " + bucket.name());
}
```



### listBuckets(ListBucketsArgs args)

`public List<Bucket> listBuckets(ListBucketsArgs args)` 

Lists bucket information of all buckets.

**Parameters**
| Parameter | Type | Description |
|:----------|:--------------------|:------------|
| `args` | ListBucketsArgs | Arguments. |

| Returns                                      |
| :------------------------------------------- |
| *List<Bucket>* - List of bucket information. |

**Example**

```java
List<Bucket> bucketList =
    ossClient.listBuckets(ListBuckets.builder().extraHeaders(headers).build());
for (Bucket bucket : bucketList) {
  System.out.println(bucket.creationDate() + ", " + bucket.name());
}
```



### listenBucketNotification(ListenBucketNotificationArgs args)

`public CloseableIterator<Result<NotificationRecords>> listenBucketNotification(ListenBucketNotificationArgs args)` 

Listens events of object prefix and suffix of a bucket. The returned closable iterator is lazily evaluated hence its required to iterate to get new records and must be used with try-with-resource to release underneath network resources.

**Parameters**
| Parameter | Type | Description |
|:----------|:---------------------------------|:------------|
| `args` | ListenBucketNotificationArgs | Arguments. |

| Returns                                                      |
| :----------------------------------------------------------- |
| *CloseableIterator<Result>* - Lazy closable iterator contains event records. |

**Example**

```java
String[] events = {"s3:ObjectCreated:*", "s3:ObjectAccessed:*"};
try (CloseableIterator<Result<NotificationRecords>> ci =
    ossClient.listenBucketNotification(
        ListenBucketNotificationArgs.builder()
            .bucket("bucketName")
            .prefix("")
            .suffix("")
            .events(events)
            .build())) {
  while (ci.hasNext()) {
    NotificationRecords records = ci.next().get();
    for (Event event : records.events()) {
      System.out.println("Event " + event.eventType() + " occurred at " + event.eventTime()
          + " for " + event.bucketName() + "/" + event.objectName());
    }
  }
}
```



### listObjects(ListObjectsArgs args)

`public Iterable<Result<Item>> listObjects(ListObjectsArgs args)` 

**Parameters**

| Parameter | Type | Description |
|:-----------------|:--------------------|:--------------------------|
| `args` | ListObjectsArgs | Arguments to list objects |

| Returns                                                      |
| :----------------------------------------------------------- |
| *Iterable<Result<Item>>* - Lazy iterator contains object information. |

**Example**

```java
// Lists objects information.
Iterable<Result<Item>> results = ossClient.listObjects(
    ListObjectsArgs.builder().bucket("my-bucketname").build());

// Lists objects information recursively.
Iterable<Result<Item>> results = ossClient.listObjects(
    ListObjectsArgs.builder().bucket("my-bucketname").recursive(true).build());

// Lists maximum 100 objects information whose names starts with 'E' and after 'ExampleGuide.pdf'.
Iterable<Result<Item>> results = ossClient.listObjects(
    ListObjectsArgs.builder()
        .bucket("my-bucketname")
        .startAfter("ExampleGuide.pdf")
        .prefix("E")
        .maxKeys(100)
        .build());

// Lists maximum 100 objects information with version whose names starts with 'E' and after
// 'ExampleGuide.pdf'.
Iterable<Result<Item>> results = ossClient.listObjects(
    ListObjectsArgs.builder()
        .bucket("my-bucketname")
        .startAfter("ExampleGuide.pdf")
        .prefix("E")
        .maxKeys(100)
        .includeVersions(true)
        .build());
```

### makeBucket(MakeBucketArgs args)

`public void makeBucket(MakeBucketArgs args)`

Creates a bucket with given region and object lock feature enabled.

**Parameters**

| Parameter | Type           | Description                |
| :-------- | :------------- | :------------------------- |
| `args`    | MakeBucketArgs | Arguments to create bucket |

**Example**

```java
// Create bucket with default region.
ossClient.makeBucket(
    MakeBucketArgs.builder()
        .bucket("my-bucketname")
        .build());

// Create bucket with specific region.
ossClient.makeBucket(
    MakeBucketArgs.builder()
        .bucket("my-bucketname")
        .region("us-west-1")
        .build());

// Create object-lock enabled bucket with specific region.
ossClient.makeBucket(
    MakeBucketArgs.builder()
        .bucket("my-bucketname")
        .region("us-west-1")
        .objectLock(true)
        .build());
```



### removeBucket(RemoveBucketArgs args)

`public void removeBucket(RemoveBucketArgs args)` 

Removes an empty bucket.

**Parameters**

| Parameter | Type             | Description |
| :-------- | :--------------- | :---------- |
| `args`    | RemoveBucketArgs | Arguments.  |

**Example**

```java
ossClient.removeBucket(RemoveBucketArgs.builder().bucket(bucketName).build());
```



### setBucketEncryption(SetBucketEncryptionArgs args)

`public void setBucketEncryption(SetBucketEncryptionArgs args)` 

Sets encryption configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:----------------------------|:------------|
| `args` | SetBucketEncryptionArgs | Arguments. |

**Example**

```java
ossClient.setBucketEncryption(
    SetBucketEncryptionArgs.builder().bucket("my-bucketname").config(config).build());
```



### setBucketLifecycle(SetBucketLifecycleArgs args)

`public void setBucketLifecycle(SetBucketLifecycleArgs args)` 

Sets lifecycle configuration to a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:---------------------------|:------------|
| `args` | SetBucketLifecycleArgs | Arguments. |

**Example**

```java
List<LifecycleRule> rules = new LinkedList<>();
rules.add(
    new LifecycleRule(
        Status.ENABLED,
        null,
        null,
        new RuleFilter("documents/"),
        "rule1",
        null,
        null,
        new Transition((ZonedDateTime) null, 30, "GLACIER")));
rules.add(
    new LifecycleRule(
        Status.ENABLED,
        null,
        new Expiration((ZonedDateTime) null, 365, null),
        new RuleFilter("logs/"),
        "rule2",
        null,
        null,
        null));
LifecycleConfiguration config = new LifecycleConfiguration(rules);
ossClient.setBucketLifecycle(
    SetBucketLifecycleArgs.builder().bucket("my-bucketname").config(config).build());
```



### setBucketNotification(SetBucketNotificationArgs args)

`public void setBucketNotification(SetBucketNotificationArgs args)`

Sets notification configuration to a bucket.

**Parameters**

| Parameter | Type                      | Description |
| :-------- | :------------------------ | :---------- |
| `args`    | SetBucketNotificationArgs | Arguments.  |

**Example**

```java
List<EventType> eventList = new LinkedList<>();
eventList.add(EventType.OBJECT_CREATED_PUT);
eventList.add(EventType.OBJECT_CREATED_COPY);

QueueConfiguration queueConfiguration = new QueueConfiguration();
queueConfiguration.setQueue("arn:minio:sqs::1:webhook");
queueConfiguration.setEvents(eventList);
queueConfiguration.setPrefixRule("images");
queueConfiguration.setSuffixRule("pg");

List<QueueConfiguration> queueConfigurationList = new LinkedList<>();
queueConfigurationList.add(queueConfiguration);

NotificationConfiguration config = new NotificationConfiguration();
config.setQueueConfigurationList(queueConfigurationList);

ossClient.setBucketNotification(
    SetBucketNotificationArgs.builder().bucket("my-bucketname").config(config).build());
```



### setBucketPolicy(SetBucketPolicyArgs args)

`public void setBucketPolicy(SetBucketPolicyArgs args)` 

Sets bucket policy configuration to a bucket.

**Parameters**

| Parameter | Type                | Description |
| :-------- | :------------------ | :---------- |
| `args`    | SetBucketPolicyArgs | Arguments.  |

**Example**

```java
// Assume policyJson contains below JSON string;
// {
//     "Statement": [
//         {
//             "Action": [
//                 "s3:GetBucketLocation",
//                 "s3:ListBucket"
//             ],
//             "Effect": "Allow",
//             "Principal": "*",
//             "Resource": "arn:aws:s3:::my-bucketname"
//         },
//         {
//             "Action": "s3:GetObject",
//             "Effect": "Allow",
//             "Principal": "*",
//             "Resource": "arn:aws:s3:::my-bucketname/myobject*"
//         }
//     ],
//     "Version": "2012-10-17"
// }
//
ossClient.setBucketPolicy(
    SetBucketPolicyArgs.builder().bucket("my-bucketname").config(policyJson).build());
```



### setBucketReplication(SetBucketReplicationArgs args)

`public void setBucketReplication(SetBucketReplicationArgs args)` 

Sets bucket replication configuration to a bucket.

**Parameters**

| Parameter | Type                     | Description |
| :-------- | :----------------------- | :---------- |
| `args`    | SetBucketReplicationArgs | Arguments.  |

**Example**

```java
Map<String, String> tags = new HashMap<>();
tags.put("key1", "value1");
tags.put("key2", "value2");

ReplicationRule rule =
    new ReplicationRule(
        new DeleteMarkerReplication(Status.DISABLED),
        new ReplicationDestination(
            null, null, "REPLACE-WITH-ACTUAL-DESTINATION-BUCKET-ARN", null, null, null, null),
        null,
        new RuleFilter(new AndOperator("TaxDocs", tags)),
        "rule1",
        null,
        1,
        null,
        Status.ENABLED);

List<ReplicationRule> rules = new LinkedList<>();
rules.add(rule);

ReplicationConfiguration config =
    new ReplicationConfiguration("REPLACE-WITH-ACTUAL-ROLE", rules);

ossClient.setBucketReplication(
    SetBucketReplicationArgs.builder().bucket("my-bucketname").config(config).build());
```



### setBucketTags(SetBucketTagsArgs args)

`public void setBucketTags(SetBucketTagsArgs args)` 

Sets tags to a bucket.

**Parameters**

| Parameter | Type              | Description |
| :-------- | :---------------- | :---------- |
| `args`    | SetBucketTagsArgs | Arguments.  |

**Example**

```java
Map<String, String> map = new HashMap<>();
map.put("Project", "Project One");
map.put("User", "jsmith");
ossClient.setBucketTags(SetBucketTagsArgs.builder().bucket("my-bucketname").tags(map).build());
```



### setBucketVersioning(SetBucketVersioningArgs args)

`public void setBucketVersioning(SetBucketVersioningArgs args)` 

Sets versioning configuration of a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:----------------------------|:------------|
| `args` | SetBucketVersioningArgs | Arguments. |

**Example**

```java
ossClient.setBucketVersioning(
    SetBucketVersioningArgs.builder().bucket("my-bucketname").config(config).build());
```



### setObjectLockConfiguration(SetObjectLockConfigurationArgs args)

`public void setObjectLockConfiguration(SetObjectLockConfigurationArgs args)` 

Sets object-lock configuration in a bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:-----------------------------------|:------------|
| `args` | SetObjectLockConfigurationArgs | Arguments. |

**Example**

```java
ObjectLockConfiguration config =
    new ObjectLockConfiguration(RetentionMode.COMPLIANCE, new RetentionDurationDays(100));
ossClient.setObjectLockConfiguration(
    SetObjectLockConfigurationArgs.builder().bucket("my-bucketname").config(config).build());
```

## 3. Object operations



### composeObject(ComposeObjectArgs args)

`public ObjectWriteResponse composeObject(ComposeObjectArgs args)` 

Creates an object by combining data from different source objects using server-side copy.

**Parameters**
| Param | Type | Description |
|:---------------|:-------------------------|:--------------|
| `args` | ComposeObjectArgs | Arguments. |

| Returns                                                      |
| :----------------------------------------------------------- |
| ObjectWriteResponse - Contains information of created object. |

**Example**

```java
List<ComposeSource> sourceObjectList = new ArrayList<ComposeSource>();
sourceObjectList.add(
  ComposeSource.builder().bucket("my-job-bucket").object("my-objectname-part-one").build());
sourceObjectList.add(
  ComposeSource.builder().bucket("my-job-bucket").object("my-objectname-part-two").build());
sourceObjectList.add(
  ComposeSource.builder().bucket("my-job-bucket").object("my-objectname-part-three").build());

// Create my-bucketname/my-objectname by combining source object list.
ossClient.composeObject(
  ComposeObjectArgs.builder()
      .bucket("my-bucketname")
      .object("my-objectname")
      .sources(sourceObjectList)
      .build());

// Create my-bucketname/my-objectname with user metadata by combining source object
// list.
Map<String, String> userMetadata = new HashMap<>();
userMetadata.put("My-Project", "Project One");
ossClient.composeObject(
    ComposeObjectArgs.builder()
      .bucket("my-bucketname")
      .object("my-objectname")
      .sources(sourceObjectList)
      .userMetadata(userMetadata)
      .build());

// Create my-bucketname/my-objectname with user metadata and server-side encryption
// by combining source object list.
ossClient.composeObject(
  ComposeObjectArgs.builder()
      .bucket("my-bucketname")
      .object("my-objectname")
      .sources(sourceObjectList)
      .userMetadata(userMetadata)
      .ssec(sse)
      .build());
```



### copyObject(CopyObjectArgs args)

`public ObjectWriteResponse copyObject(CopyObjectArgs args)` 

Creates an object by server-side copying data from another object.

**Parameters**
| Parameter | Type | Description |
|:----------|:-------------------|:------------|
| `args` | CopyObjectArgs | Arguments. |

| Returns                                                      |
| :----------------------------------------------------------- |
| ObjectWriteResponse - Contains information of created object. |

**Example**

```java
// Create object "my-objectname" in bucket "my-bucketname" by copying from object
// "my-objectname" in bucket "my-source-bucketname".
ossClient.copyObject(
    CopyObjectArgs.builder()
        .bucket("my-bucketname")
        .object("my-objectname")
        .srcBucket("my-source-bucketname")
        .build());

// Create object "my-objectname" in bucket "my-bucketname" by copying from object
// "my-source-objectname" in bucket "my-source-bucketname".
ossClient.copyObject(
    CopyObjectArgs.builder()
        .bucket("my-bucketname")
        .object("my-objectname")
        .srcBucket("my-source-bucketname")
        .srcObject("my-source-objectname")
        .build());

// Create object "my-objectname" in bucket "my-bucketname" with server-side encryption by
// copying from object "my-objectname" in bucket "my-source-bucketname".
ossClient.copyObject(
    CopyObjectArgs.builder()
        .bucket("my-bucketname")
        .object("my-objectname")
        .srcBucket("my-source-bucketname")
        .sse(sse)
        .build());

// Create object "my-objectname" in bucket "my-bucketname" by copying from SSE-C encrypted
// object "my-source-objectname" in bucket "my-source-bucketname".
ossClient.copyObject(
    CopyObjectArgs.builder()
        .bucket("my-bucketname")
        .object("my-objectname")
        .srcBucket("my-source-bucketname")
        .srcObject("my-source-objectname")
        .srcSsec(ssec)
        .build());

// Create object "my-objectname" in bucket "my-bucketname" with custom headers by copying from
// object "my-objectname" in bucket "my-source-bucketname" using conditions.
ossClient.copyObject(
    CopyObjectArgs.builder()
        .bucket("my-bucketname")
        .object("my-objectname")
        .srcBucket("my-source-bucketname")
        .headers(headers)
        .srcMatchETag(etag)
        .build());
```



### deleteObjectTags(DeleteObjectTagsArgs args)

`private void deleteObjectTags(DeleteObjectTagsArgs args)` 

Deletes tags of an object.

**Parameters**

| Parameter | Type | Description |
|:----------|:-------------------------|:------------|
| `args` | DeleteObjectTagsArgs | Arguments. |

**Example**

```java
ossClient.deleteObjectTags(
    DeleteObjectArgs.builder().bucket("my-bucketname").object("my-objectname").build());
```



### disableObjectLegalHold(DisableObjectLegalHoldArgs args)

`public void disableObjectLegalHold(DisableObjectLegalHoldArgs args)` 

Disables legal hold on an object.

**Parameters**

| Parameter | Type                       | Description |
| :-------- | :------------------------- | :---------- |
| `args`    | DisableObjectLegalHoldArgs | Arguments.  |

**Example**

```java
// Disables legal hold on an object.
ossClient.disableObjectLegalHold(
    DisableObjectLegalHoldArgs.builder()
        .bucket("my-bucketname")
        .object("my-objectname")
        .build());
```



### enableObjectLegalHold(EnableObjectLegalHoldArgs args)

`public void enableObjectLegalHold(EnableObjectLegalHoldArgs args)` 

Enables legal hold on an object.

**Parameters**

| Parameter | Type                      | Description |
| :-------- | :------------------------ | :---------- |
| `args`    | EnableObjectLegalHoldArgs | Argumments. |

**Example**

```java
// Disables legal hold on an object.
ossClient.enableObjectLegalHold(
    EnableObjectLegalHoldArgs.builder()
        .bucket("my-bucketname")
        .object("my-objectname")
        .build());
```



### getObject(GetObjectArgs args)

`public InputStream getObject(GetObjectArgs args)` 

Gets data of an object. Returned `InputStream` must be closed after use to release network resources.

**Parameters**
| Parameter | Type | Description |
|:---------------|:----------------|:---------------------------|
| `args` | *GetObjectArgs* | Arguments. |

| Returns                               |
| :------------------------------------ |
| *InputStream* - Contains object data. |

**Example**

```java
// get object given the bucket and object name
try (InputStream stream = ossClient.getObject(
  GetObjectArgs.builder()
  .bucket("my-bucketname")
  .object("my-objectname")
  .build()) {
  // Read data from stream
}

// get object data from offset
try (InputStream stream = ossClient.getObject(
  GetObjectArgs.builder()
  .bucket("my-bucketname")
  .object("my-objectname")
  .offset(1024L)
  .build()) {
  // Read data from stream
}

// get object data from offset to length
try (InputStream stream = ossClient.getObject(
  GetObjectArgs.builder()
  .bucket("my-bucketname")
  .object("my-objectname")
  .offset(1024L)
  .length(4096L)
  .build()) {
  // Read data from stream
}

// get data of an SSE-C encrypted object
try (InputStream stream = ossClient.getObject(
  GetObjectArgs.builder()
  .bucket("my-bucketname")
  .object("my-objectname")
  .ssec(ssec)
  .build()) {
  // Read data from stream
}

// get object data from offset to length of an SSE-C encrypted object
try (InputStream stream = ossClient.getObject(
  GetObjectArgs.builder()
  .bucket("my-bucketname")
  .object("my-objectname")
  .offset(1024L)
  .length(4096L)
  .ssec(ssec)
  .build()) {
  // Read data from stream
}
```



### downloadObject(DownloadObjectArgs args)

`public void downloadObject(DownloadObjectArgs args)`

Downloads data of an object to file.

**Parameters**

| Parameter | Type | Description |
|:-----------------|:---------------------|:-----------------------------|
| `args` | *DownloadObjectArgs* | Arguments. |

**Example**

```java
// Download object given the bucket, object name and output file name
ossClient.downloadObject(
  DownloadObjectArgs.builder()
  .bucket("my-bucketname")
  .object("my-objectname")
  .fileName("my-object-file")
  .build());

// Download server-side encrypted object in bucket to given file name
ossClient.downloadObject(
  DownloadObjectArgs.builder()
  .bucket("my-bucketname")
  .object("my-objectname")
  .ssec(ssec)
  .fileName("my-object-file")
  .build());
```



### getObjectRetention(GetObjectRetentionArgs args)

`public Retention getObjectRetention(GetObjectRetentionArgs args)` 

Gets retention configuration of an object.

**Parameters**

| Parameter | Type                   | Description |
| :-------- | :--------------------- | :---------- |
| `args`    | GetObjectRetentionArgs | Arguments.  |

| Returns                                     |
| :------------------------------------------ |
| Retention - Object retention configuration. |

**Example**

```java
// Object with version id.
Retention retention =
    ossClient.getObjectRetention(
        GetObjectRetentionArgs.builder()
            .bucket("my-bucketname")
            .object("my-objectname")
            .versionId("object-version-id")
            .build());
System.out.println("mode: " + retention.mode() + "until: " + retention.retainUntilDate());
```



### getObjectTags(GetObjectTagsArgs args)

`public Tags getObjectTags(GetObjectTagsArgs args)` 

Gets tags of an object.

**Parameters**
| Parameter | Type | Description |
|:----------|:----------------------|:------------|
| `args` | GetObjectTagsArgs | Arguments. |

| Returns        |
| :------------- |
| *Tags* - tags. |

**Example**

```java
Tags tags = ossClient.getObjectTags(
    GetObjectTagsArgs.builder().bucket("my-bucketname").object("my-objectname").build());
```



### getPresignedObjectUrl(GetPresignedObjectUrlArgs args)

`public String getPresignedObjectUrl(GetPresignedObjectUrlArgs args)` 

Gets presigned URL of an object for HTTP method, expiry time and custom request parameters.

**Parameters**
| Parameter | Type | Description |
|:------------|:-------------------------------|:-------------|
| `args` | GetPresignedObjectUrlArgs | Arguments. |

| Returns                |
| :--------------------- |
| *String* - URL string. |

**Example**

```java
// Get presigned URL of an object for HTTP method, expiry time and custom request parameters.
String url =
    ossClient.getPresignedObjectUrl(
        GetPresignedObjectUrlArgs.builder()
            .method(Method.DELETE)
            .bucket("my-bucketname")
            .object("my-objectname")
            .expiry(24 * 60 * 60)
            .build());
System.out.println(url);

// Get presigned URL string to upload 'my-objectname' in 'my-bucketname' 
// with response-content-type as application/json and life time as one day.
Map<String, String> reqParams = new HashMap<String, String>();
reqParams.put("response-content-type", "application/json");

String url =
    ossClient.getPresignedObjectUrl(
        GetPresignedObjectUrlArgs.builder()
            .method(Method.PUT)
            .bucket("my-bucketname")
            .object("my-objectname")
            .expiry(1, TimeUnit.DAYS)
            .extraQueryParams(reqParams)
            .build());
System.out.println(url);

// Get presigned URL string to download 'my-objectname' in 'my-bucketname' and its life time
// is 2 hours.
String url =
    ossClient.getPresignedObjectUrl(
        GetPresignedObjectUrlArgs.builder()
            .method(Method.GET)
            .bucket("my-bucketname")
            .object("my-objectname")
            .expiry(2, TimeUnit.HOURS)
            .build());
System.out.println(url);
```



### isObjectLegalHoldEnabled(IsObjectLegalHoldEnabledArgs args)

`public boolean isObjectLegalHoldEnabled(IsObjectLegalHoldEnabledArgs args)` 

Returns true if legal hold is enabled on an object.

**Parameters**

| Parameter | Type                         | Description |
| :-------- | :--------------------------- | :---------- |
| `args`    | IsObjectLegalHoldEnabledArgs | Arguments.  |

| Returns                                    |
| :----------------------------------------- |
| *boolean* - True if legal hold is enabled. |

**Example**

```java
boolean status =
    s3Client.isObjectLegalHoldEnabled(
       IsObjectLegalHoldEnabledArgs.builder()
            .bucket("my-bucketname")
            .object("my-objectname")
            .versionId("object-versionId")
            .build());
if (status) {
  System.out.println("Legal hold is on");
else {
  System.out.println("Legal hold is off");
}
```



### getPresignedPostFormData(PostPolicy policy)

`public Map<String,String> getPresignedPostFormData(PostPolicy policy)` 

Gets form-data of PostPolicy of an object to upload its data using POST method.

**Parameters**

| Parameter | Type | Description |
|:-----------|:---------------|:--------------------------|
| `policy` | *PostPolicy* | Post policy of an object. |

| Returns                                                      |
| :----------------------------------------------------------- |
| *Map* - Contains form-data to upload an object using POST method. |

**Example**

```java
// Create new post policy for 'my-bucketname' with 7 days expiry from now.
PostPolicy policy = new PostPolicy("my-bucketname", ZonedDateTime.now().plusDays(7));

// Add condition that 'key' (object name) equals to 'my-objectname'.
policy.addEqualsCondition("key", "my-objectname");

// Add condition that 'Content-Type' starts with 'image/'.
policy.addStartsWithCondition("Content-Type", "image/");

// Add condition that 'content-length-range' is between 64kiB to 10MiB.
policy.addContentLengthRangeCondition(64 * 1024, 10 * 1024 * 1024);

Map<String, String> formData = ossClient.getPresignedPostFormData(policy);

// Upload an image using POST object with form-data.
MultipartBody.Builder multipartBuilder = new MultipartBody.Builder();
multipartBuilder.setType(MultipartBody.FORM);
for (Map.Entry<String, String> entry : formData.entrySet()) {
  multipartBuilder.addFormDataPart(entry.getKey(), entry.getValue());
}
multipartBuilder.addFormDataPart("key", "my-objectname");
multipartBuilder.addFormDataPart("Content-Type", "image/png");

// "file" must be added at last.
multipartBuilder.addFormDataPart(
    "file", "my-objectname", RequestBody.create(new File("Pictures/avatar.png"), null));

Request request =
    new Request.Builder()
        .url("https://127.0.0.1/my-bucketname")
        .post(multipartBuilder.build())
        .build();
OkHttpClient httpClient = new OkHttpClient().newBuilder().build();
Response response = httpClient.newCall(request).execute();
if (response.isSuccessful()) {
  System.out.println("Pictures/avatar.png is uploaded successfully using POST object");
} else {
  System.out.println("Failed to upload Pictures/avatar.png");
}
```



### putObject(PutObjectArgs args)

`public ObjectWriteResponse putObject(PutObjectArgs args)` 

Uploads given stream as object in bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:------------------|:------------|
| `args` | PutObjectArgs | Arguments. |

| Returns                                                      |
| :----------------------------------------------------------- |
| ObjectWriteResponse - Contains information of created object. |

**Example**

```java
// Upload known sized input stream.
ossClient.putObject(
    PutObjectArgs.builder().bucket("my-bucketname").object("my-objectname").stream(
            inputStream, size, -1)
        .contentType("video/mp4")
        .build());

// Upload unknown sized input stream.
ossClient.putObject(
    PutObjectArgs.builder().bucket("my-bucketname").object("my-objectname").stream(
            inputStream, -1, 10485760)
        .contentType("video/mp4")
        .build());

// Create object ends with '/' (also called as folder or directory).
ossClient.putObject(
    PutObjectArgs.builder().bucket("my-bucketname").object("path/to/").stream(
            new ByteArrayInputStream(new byte[] {}), 0, -1)
        .build());

// Upload input stream with headers and user metadata.
Map<String, String> headers = new HashMap<>();
headers.put("X-Amz-Storage-Class", "REDUCED_REDUNDANCY");
Map<String, String> userMetadata = new HashMap<>();
userMetadata.put("My-Project", "Project One");
ossClient.putObject(
    PutObjectArgs.builder().bucket("my-bucketname").object("my-objectname").stream(
            inputStream, size, -1)
        .headers(headers)
        .userMetadata(userMetadata)
        .build());

// Upload input stream with server-side encryption.
ossClient.putObject(
    PutObjectArgs.builder().bucket("my-bucketname").object("my-objectname").stream(
            inputStream, size, -1)
        .sse(sse)
        .build());
```



### uploadObject(UploadObjectArgs args)

`public void uploadObject(UploadObjectArgs args)` 

Uploads contents from a file as object in bucket.

**Parameters**
| Parameter | Type | Description |
|:----------|:---------------------|:------------|
| `args` | UploadObjectArgs | Arguments. |

**Example**

```java
// Upload an JSON file.
ossClient.uploadObject(
    UploadObjectArgs.builder()
        .bucket("my-bucketname").object("my-objectname").filename("person.json").build());

// Upload a video file.
ossClient.uploadObject(
    UploadObjectArgs.builder()
        .bucket("my-bucketname")
        .object("my-objectname")
        .filename("my-video.avi")
        .contentType("video/mp4")
        .build());
```



### removeObject(RemoveObjectArgs args)

`public void removeObject(RemoveObjectArgs args)` 

Removes an object.

**Parameters**
| Parameter | Type | Description |
|:----------|:---------------------|:------------|
| `args` | RemoveObjectArgs | Arguments. |

**Example**

```java
// Remove object.
ossClient.removeObject(
    RemoveObjectArgs.builder().bucket("my-bucketname").object("my-objectname").build());

// Remove versioned object.
ossClient.removeObject(
    RemoveObjectArgs.builder()
        .bucket("my-bucketname")
        .object("my-versioned-objectname")
        .versionId("my-versionid")
        .build());

// Remove versioned object bypassing Governance mode.
ossClient.removeObject(
    RemoveObjectArgs.builder()
        .bucket("my-bucketname")
        .object("my-versioned-objectname")
        .versionId("my-versionid")
        .bypassRetentionMode(true)
        .build());
```



### removeObjects(RemoveObjectsArgs args)

`public Iterable<Result<DeleteError>> removeObjects(RemoveObjectsArgs args)`

Removes multiple objects lazily. Its required to iterate the returned Iterable to perform removal.

**Parameters**
| Parameter | Type | Description |
|:----------|:----------------------|:------------|
| `args` | RemoveObjectsArgs | Arguments. |

| Returns                                                      |
| :----------------------------------------------------------- |
| *Iterable<Result<DeleteError>>* - Lazy iterator contains object removal status. |

**Example**

```java
List<DeleteObject> objects = new LinkedList<>();
objects.add(new DeleteObject("my-objectname1"));
objects.add(new DeleteObject("my-objectname2"));
objects.add(new DeleteObject("my-objectname3"));
Iterable<Result<DeleteError>> results =
    ossClient.removeObjects(
        RemoveObjectsArgs.builder().bucket("my-bucketname").objects(objects).build());
for (Result<DeleteError> result : results) {
  DeleteError error = result.get();
  System.out.println(
      "Error in deleting object " + error.objectName() + "; " + error.message());
}
```



### selectObjectContent(SelectObjectContentArgs args)

`public SelectResponseStream selectObjectContent(SelectObjectContentArgs args)` 

Selects content of a object by SQL expression.

**Parameters**

| Parameter | Type                    | Description |
| :-------- | :---------------------- | :---------- |
| `args`    | SelectObjectContentArgs | Arguments.  |

| Returns                                                      |
| :----------------------------------------------------------- |
| SelectResponseStream - Contains filtered records and progress. |

**Example**

```java
String sqlExpression = "select * from S3Object";
InputSerialization is = new InputSerialization(null, false, null, null, FileHeaderInfo.USE, null, null, null);
OutputSerialization os = new OutputSerialization(null, null, null, QuoteFields.ASNEEDED, null);
SelectResponseStream stream =
    ossClient.selectObjectContent(
        SelectObjectContentArgs.builder()
            .bucket("my-bucketname")
            .object("my-objectName")
            .sqlExpression(sqlExpression)
            .inputSerialization(is)
            .outputSerialization(os)
            .requestProgress(true)
            .build());

byte[] buf = new byte[512];
int bytesRead = stream.read(buf, 0, buf.length);
System.out.println(new String(buf, 0, bytesRead, StandardCharsets.UTF_8));

Stats stats = stream.stats();
System.out.println("bytes scanned: " + stats.bytesScanned());
System.out.println("bytes processed: " + stats.bytesProcessed());
System.out.println("bytes returned: " + stats.bytesReturned());

stream.close();
```



### setObjectRetention(SetObjectRetentionArgs args)

`public void setObjectLockRetention(SetObjectRetentionArgs)` 

Sets retention configuration to an object.

**Parameters**

| Parameter | Type                   | Description |
| :-------- | :--------------------- | :---------- |
| `args`    | SetObjectRetentionArgs | Arguments.  |

**Example**

```java
Retention retention = new Retention(RetentionMode.COMPLIANCE, ZonedDateTime.now().plusYears(1));
ossClient.setObjectRetention(
    SetObjectRetentionArgs.builder()
        .bucket("my-bucketname")
        .object("my-objectname")
        .config(retention)
        .bypassGovernanceMode(true)
        .build());
```



### setObjectTags(SetObjectTagsArgs args)

`public void setObjectTags(SetObjectTagsArgs args)` 

Sets tags to an object.

**Parameters**

| Parameter | Type              | Description |
| :-------- | :---------------- | :---------- |
| `args`    | SetObjectTagsArgs | Arguments.  |

**Example**

```java
Map<String, String> map = new HashMap<>();
map.put("Project", "Project One");
map.put("User", "jsmith");
ossClient.setObjectTags(
    SetObjectTagsArgs.builder().bucket("my-bucketname").object("my-objectname").tags(map).build());
```



### statObject(StatObjectArgs args)

`public ObjectStat statObject(StatObjectArgs args)` 

Gets object information and metadata of an object.

**Parameters**
| Parameter | Type | Description |
|:----------|:-------------------|:------------|
| `args` | StatObjectArgs | Arguments. |

| Returns                                                 |
| :------------------------------------------------------ |
| ObjectStat - Populated object information and metadata. |

**Example**

```java
// Get information of an object.
ObjectStat objectStat =
    ossClient.statObject(
        StatObjectArgs.builder().bucket("my-bucketname").object("my-objectname").build());

// Get information of SSE-C encrypted object.
ObjectStat objectStat =
    ossClient.statObject(
        StatObjectArgs.builder()
            .bucket("my-bucketname")
            .object("my-objectname")
            .ssec(ssec)
            .build());

// Get information of a versioned object.
ObjectStat objectStat =
    ossClient.statObject(
        StatObjectArgs.builder()
            .bucket("my-bucketname")
            .object("my-objectname")
            .versionId("version-id")
            .build());

// Get information of a SSE-C encrypted versioned object.
ObjectStat objectStat =
    ossClient.statObject(
        StatObjectArgs.builder()
            .bucket("my-bucketname")
            .object("my-objectname")
            .versionId("version-id")
            .ssec(ssec)
            .build());
```

