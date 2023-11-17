## Running locally - Manually with npm 

1. Clone this repository or download the source code.
2. Install the dependencies by running the following command: 
  ```bash
    $ npm install
  ```
3. Set up the required environment variables. Create a .env file in the root directory and add the following variables:
   
   PORT

   MONGO_URL

4. Start the development server with the following command: 
 ```bash
    $ npm run dev
 ```

5. Start the main/production server with the following command
```bash
    $ npm run start
 ```


 docker run \
  --name postgres \
  --detach \
  --env POSTGRES_PASSWORD=segun123 \
  --publish=5432:5432 \
  postgres:latest