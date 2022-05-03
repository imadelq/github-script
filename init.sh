 #!/usr/bin/env bash

 read -p "Input your github token : " -s token
 echo ""
 encryptedToken=$(echo $token | openssl aes-256-cbc -pbkdf2 -e -a) && echo "Encrypted token : " && echo $encryptedToken
