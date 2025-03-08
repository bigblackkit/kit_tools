#Delete service from namespace
kubectl delete service <YourServiceName> --namespace <YourServiceNameSpace>




helm upgrade kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -f values.yml -n kubernetes-dashboard


kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'


kubectl -n argocd get secret argocd-initial-admin-secret \-o jsonpath="{.data.password}" | base64 -d


$ argocd version
argocd: v1.8.5+d0f8edf
  BuildDate: 2021-02-20T05:38:50Z
  GitCommit: d0f8edfec804c013d4fc535e8b9022eb47602617
  GitTreeState: clean
  GoVersion: go1.14.12
  Compiler: gc
  Platform: linux/amd64
FATA[0000] Argo CD server address unspecified     

 $ k get svc argocd-server -n argocd
NAME            TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)                      AGE
argocd-server   LoadBalancer   xxxxxx   ${EXTERNAL-IP}   80:30581/TCP,443:31692/TCP   xxxx


$ k get svc argocd-server -n argocd
NAME            TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)                      AGE
argocd-server   LoadBalancer   xxxxxx   ${EXTERNAL-IP}   80:30581/TCP,443:31692/TCP   xxxx

argocd --insecure login ${EXTERNAL-IP}:443
Username: admin
Password: 
Password: 
'admin' logged in successfully
Context '${EXTERNAL-IP}:443' updated

$ argocd repo add git@gitlab.com:${ACCOUNTNAME}/${MANIFEST_ROOT_DIR}.git \
> --ssh-private-key-path /${HOME}/.ssh/id_rsa
repository 'git@gitlab.com:${ACCOUNTNAME}/${MANIFEST_ROOT_DIR}.git' added

$ argocd app create hello-python \
--repo git@gitlab.com::${ACCOUNTNAME}/${MANIFEST_ROOT_DIR}.git  \
--path manifests --dest-server https://kubernetes.default.svc --dest-namespace ${APPNAMESPACE} \
--revision ${BRANCHNAME} --sync-policy automated --auto-prune --self-heal