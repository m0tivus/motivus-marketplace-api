mix phx.gen.json PackageRegistry Algorithm algorithms --web PackageRegistry \
  name:string \
  is_public:boolean \
  cost:float \
  charge_schema:string
sleep 2

mix phx.gen.json PackageRegistry Version versions --web PackageRegistry \
  algorithm_id:references:algorithms \
  name:string \
  metadata:map \
  hash:string \
  wasm_url:string \
  loader_url:string \
  data_url:string 
sleep 2

mix phx.gen.json Account User users --web Account \
  email:string \
  username:string \
  avatar_url:string \
  provider:string \
  uuid:uuid
sleep 2

mix phx.gen.json Account ApplicationToken application_tokens --web Account \
  user_id:references:users \
  value:string \
  valid:boolean \
  description:string
sleep 2

mix phx.gen.json Account PersonalAccessToken personal_access_tokens --web Account \
  user_id:references:users \
  value:string \
  valid:boolean \
  description:string
sleep 2

mix phx.gen.json PackageRegistry AlgorithmUser algorithm_users --web PackageRegistry \
  algorithm_id:references:algorithms \
  user_id:references:users \
  role:string \
  cost:float \
  charge_schema:string
sleep 2

