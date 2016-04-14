//
//  TipoContasViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class TipoContasViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var tipoConta: TipoConta?
    var tipoContaDAO: TipoContaDAO = TipoContaDAO()
    var erros: String = ""
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var txtNome: UITextField!

    @IBOutlet var textViews:[UITextField]!
    
    // MARK: - Private Functions
    
    private func addDismissInputView() {
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismiss:"))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Selector Functions
    
    func dismiss(sender: UITapGestureRecognizer? = nil) {
        FormCustomization.dismissInputView(textViews)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tipoConta = tipoConta{
            txtNome.text = tipoConta.nome!
        }
        
        FormCustomization.alignLabelsWidths(labels)
        addDismissInputView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    // MARK: - IBAction functions
    
    @IBAction func btnCancel(sender: AnyObject) {
        
        dissmissViewController()
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
        addConta()
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    // MARK: - Private functions
    
    private func dissmissViewController(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func validarCampos(){
        if Validador.vazio(txtNome.text!){
            erros.appendContentsOf("\nPreencha o campo nome!")
        }
    }
    
    private func addConta(){
        
        validarCampos()

        if (erros.isEmpty){
            tipoConta = TipoConta.getTipoConta()
            tipoConta?.nome = txtNome.text
            
            salvarConta()

        }else{
            let alert = Notification.mostrarErro("Campo vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            self.erros = ""
        }
    }
    
    private func salvarConta(){
        
        do {
            
            try tipoContaDAO.salvar(tipoConta!)
        } catch {
            
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível salvar")
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
