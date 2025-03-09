//
//  BiometricAuthentication.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 25/06/23.
//

import Foundation
import LocalAuthentication

public class BiometricAuthentication: ObservableObject {
    
    
    @Published var unlocked : Bool = false
    
    public func authenticate(){
        
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            // we are good to go, we can use biometrics
            let argument = "we need to unlock your Data" // asking for permission
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: argument) { success, authenticationError in
                
                if success { // authentication sucessfully
                    self.unlocked = true
                } else { // there was a problem
                    
                }
            }
            
            
        } else { // Not capable of using Biometrics
            
        }
    }
    
}
