db.createUser({
  user: "fleets",
  pwd: "password1234",
  roles: [
    {
      role: "readWrite",
      db: "fleets",
    },
  ],
});
