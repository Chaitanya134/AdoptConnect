import axios from "axios";
import React, { useState } from "react";
import { Header } from "../components";
import PopUp from "../components/Modal/PopUp";

const EditProfile = () => {
  const currentuser = JSON.parse(localStorage.getItem("userDetails"));
  const [userId, setuserId] = useState(currentuser.user_id);
  const [userName, setuserName] = useState(currentuser.name);
  const [userEmail, setuserEmail] = useState(currentuser.email);
  const [userCat, setuserCat] = useState(currentuser.category);
  const [userPass, setuserPass] = useState(currentuser.password);
  const [userZone, setuserZone] = useState(currentuser.zone);
  const [userAddress, setuserAddress] = useState(currentuser.address);
  const [userAadhar, setuserAadhar] = useState(currentuser.aadharCardNo);
  const [userContact, setuserContact] = useState(currentuser.contactNo);

  const [openPopUp, setopenPopUp] = useState(false);

  const updateProfileHandler = async () => {
    const response = await axios.post("http://localhost:3000/users/update", {
      user_id: userId,
      name: userName,
      email: userEmail,
      category: userCat,
      password: userPass,
      zone: userZone,
      address: userAddress,
      aadharCardNo: userAadhar,
      contactNo: userContact,
    });
    if (response.data.response) {
      localStorage.setItem(
        "userDetails",
        JSON.stringify(response.data.response)
      );
      setopenPopUp(true);
    }
  };

  return (
    <div className="m-2 md:m-10 mt-24 p-2 md:p-10 bg-white rounded-3xl ">
      <Header category="App" title="Edit Profile" />
      <div>
        {openPopUp ? (
          <PopUp
            message={"Profile succesfully updated"}
            status={true}
            setopenPopUp={setopenPopUp}
            heading={"Success"}
          />
        ) : (
          ""
        )}
        <div className="container max-w-screen-lg mx-auto">
          <div>
            <div className="bg-white rounded p-4 px-4 md:p-8 mb-6">
              <div className="grid gap-4 gap-y-2 text-sm grid-cols-1 lg:grid-cols-3">
                <div className="lg:col-span-3">
                  <div className="grid gap-4 gap-y-2 text-sm grid-cols-1 md:grid-cols-5">
                    <div className="md:col-span-5">
                      <label htmlFor="user_id">User ID</label>
                      <input
                        type="text"
                        name="user_id"
                        id="user_id"
                        className="h-10 cursor-not-allowed border mt-1 rounded px-4 w-full bg-gray-50"
                        value={userId}
                        disabled
                      />
                    </div>
                    <div className="md:col-span-5">
                      <label htmlFor="full_name">Full Name</label>
                      <input
                        type="text"
                        name="full_name"
                        id="full_name"
                        className="h-10 border mt-1 rounded px-4 w-full bg-gray-50"
                        value={userName}
                        onChange={(e) => setuserName(e.target.value)}
                      />
                    </div>
                    <div className="md:col-span-5">
                      <label htmlFor="email">Email Address</label>
                      <input
                        type="text"
                        name="email"
                        id="email"
                        className="h-10 border mt-1 rounded px-4 w-full bg-gray-50"
                        value={userEmail}
                        onChange={(e) => setuserEmail(e.target.value)}
                        placeholder="email@domain.com"
                      />
                    </div>
                    <div className="md:col-span-5 cursor-not-allowed">
                      <label htmlFor="email">Role</label>
                      <select
                        name="email"
                        id="email"
                        className="h-10 border mt-1 rounded px-4 w-full bg-gray-50 cursor-not-allowed"
                        // onChange={(e) => setuserCat(e.target.value)}
                        placeholder="email@domain.com"
                        disabled
                      >
                        <option value="worker">Grass Root Worker</option>
                        <option value="case-manager">Case Managment</option>
                      </select>
                    </div>
                    <div className="md:col-span-5">
                      <label htmlFor="pass">Address</label>
                      <input
                        type="text"
                        name="pass"
                        id="pass"
                        className="h-10 border mt-1 rounded px-4 w-full bg-gray-50"
                        value={userAddress}
                        onChange={(e) => setuserAddress(e.target.value)}
                        placeholder=""
                      />
                    </div>
                    <div className="md:col-span-5">
                      <label htmlFor="pass">Aadhar Card Number</label>
                      <input
                        type="text"
                        name="pass"
                        id="pass"
                        className="h-10 border mt-1 rounded px-4 w-full bg-gray-50"
                        value={userAadhar}
                        onChange={(e) => setuserAadhar(e.target.value)}
                        placeholder=""
                      />
                    </div>
                    <div className="md:col-span-5">
                      <label htmlFor="pass">Contact Number</label>
                      <input
                        type="text"
                        name="pass"
                        id="pass"
                        className="h-10 border mt-1 rounded px-4 w-full bg-gray-50"
                        value={userContact}
                        onChange={(e) => setuserContact(e.target.value)}
                        placeholder=""
                      />
                    </div>
                    <div className="md:col-span-5">
                      <label htmlFor="pass">Zone</label>
                      <input
                        type="text"
                        name="pass"
                        id="pass"
                        className="h-10 border mt-1 rounded px-4 w-full bg-gray-50"
                        value={userZone}
                        onChange={(e) => setuserZone(e.target.value)}
                        placeholder=""
                      />
                    </div>
                    <div className="md:col-span-5 text-right">
                      <div className="inline-flex items-end">
                        <button
                          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                          onClick={() => updateProfileHandler()}
                        >
                          Submit
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default EditProfile;