#! /bin/bash -x
echo "Deploying gopalashringar/server to google cloud \n"

# returns a list of all deployment versions
gcloud_list() {
    local gcloud="$(gcloud app versions list)"
    local array=()
    for word in $gcloud
    do
        array+=($word)
    done
    echo "${array[@]}"
}

#delete unneccessary deployments that are not utilized
delete_version() {
    local array=($@)
    for ((i=0; i < ${#array[@]}; ++i)); do
        if [[ ${array[$i]} == *"0.00"* ]]; then
            local version=${array[$i - 1]}
            local command="gcloud -q app versions delete $version"
            eval $command
        fi
    done
}

# execute function
list=$(gcloud_list)
delete_version $list

#deploy to google cloud provider
gcloud app deploy --stop-previous-version