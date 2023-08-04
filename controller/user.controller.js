const UserService= require("../services/user.services"); 

exports.register = async(req, res, next)=>{

    try{
        const {email, password} = req.body;

        const successRes = await UserService.registerUser(email, password);

        res.json({status:true, success:"User registered succesfully" });
    }catch(error){
        throw error
    }
}

exports.login = async(req, res, next)=>{

    try{
        const {email, password} = req.body;
        
        const user = await UserService.checkuser(email);

        if(!user){

            throw new Error("User dont exist");
            
        }
        
        const isMatch = await user.comparePassword(password);

        if(isMatch === false){
            throw new Error("Password is invalid");
        }


        let tokenData = {_id: user._id, email: user.email, password:user.password};
    
        const token = await UserService.generateToken(tokenData,"secretKey", '1h')

        res.status(200).json({status:true, token:token})

    }catch(error){
        throw error
    }

}

    exports.getUserIdByEmail = async (req, res, next) => {
        try {
            const { email } = req.query; // Assuming the email will be passed as a query parameter
    
            // Get the userId based on the user's email
            const userId = await UserService.getUserIdByEmail(email);
    
            if (userId) {
                res.status(200).json({ status: true, userId });
            } else {
                res.status(404).json({ status: false, message: "User not found" });
            }
        } catch (error) {
            throw error;
        }
    }
        exports.getEmailByUserId = async (req, res, next) => {
            try {
                const { userId } = req.query; // Assuming the email will be passed as a query parameter
        
                // Get the userId based on the user's email
                const email = await UserService.getEmailByUserId(userId);
        
                if (email) {
                    res.status(200).json({ status: true, userId });
                } else {
                    res.status(404).json({ status: false, message: "User not found" });
                }
            } catch (error) {
                throw error;
            }
}